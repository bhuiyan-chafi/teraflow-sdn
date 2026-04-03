# Copyright 2022-2025 ETSI SDG TeraFlowSDN (TFS) (https://tfs.etsi.org/)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# [CHAFI-THESIS-START]
# Parallel Optical Controller - Custom RSA Implementation for TeraFlowSDN
# [CHAFI-THESIS-END]

import logging
import time
from flask import Flask, request
from flask_restplus import Resource, Api

# [CHAFI-THESIS-START] - Import RSA Helper Module
from .RSA import get_required_bandwidth, DEFAULT_MODULATION, DEFAULT_ROLL_OFF_FACTOR
# [CHAFI-THESIS-END]

# [CHAFI-THESIS-START] - Import Topology Module for NetworkX graph building
from .topology import build_graph, fetch_optical_links_for_rsa, find_paths
# [CHAFI-THESIS-END]

# [CHAFI-THESIS-START] - Import RSAHelper for spectrum assignment computation
from .RSAHelper import OpticalLinksCache, TopologyHelper
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - Import ContextClient for DB updates
from context.client.ContextClient import ContextClient
# [CHAFI-THESIS-END]

# [CHAFI-THESIS-START] - Import Common Proto and Tools
from common.proto.context_pb2 import (
    OpticalConfig, OpticalConfigId, Empty, ServiceId,
    ServiceStatusEnum, ContextId, LinkId
)
from common.tools.context_queries.OpticalConfig import opticalconfig_uuid_get_duuid
from common.DeviceTypes import DeviceTypeEnum
import json
import traceback
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - Configure logging with timestamps
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
LOGGER = logging.getLogger(__name__)
# [CHAFI-THESIS-END]

# [CHAFI-THESIS-START] - Flask Application setup
app = Flask(__name__)
api = Api(app, version='1.0', title='Parallel Optical Controller API',
          description='Custom RSA REST API for TeraFlowSDN Optical Services')

# API Namespace
optical = api.namespace('ParallelOpticalTFS',
                        description='Parallel Optical Controller APIs')
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - In-memory storage for lightpaths (similar to opticalcontroller's rsa.db_flows)
# Storage structure mirrors opticalcontroller for compatibility
db_flows = {}  # flow_id -> lightpath data
flow_counter = 0  # Auto-increment flow ID
# [CHAFI-THESIS-END]


@app.route('/health')
def health():
    """Health check endpoint"""
    return {"status": "healthy"}, 200


@optical.route('/GetStatus')
@optical.response(200, 'Success')
class GetStatus(Resource):
    @staticmethod
    def get():
        """Get controller status"""
        # LOGGER.info(
        #     "[CHAFI-RSA] GetStatus: {} lightpaths".format(len(db_flows)))
        return {
            "service": "parallelopticalcontroller",
            "status": "running",
            "version": "1.0.0",
            "lightpaths_count": len(db_flows)
        }, 200


# [CHAFI-THESIS-START] - Endpoint to sync topology from TFS
@optical.route('/GetTopology/<path:context_id>/<path:topology_id>')
@optical.response(200, 'Success')
class GetTopology(Resource):
    @staticmethod
    def get(context_id, topology_id):
        """
        [CHAFI-PARALLEL-OPTICAL] Sync topology from TFS context service.
        This is called by ServiceService to initialize the controller.
        """
        # LOGGER.info(
        #     "[CHAFI-RSA] GetTopology: context={}, topology={}".format(context_id, topology_id))
        return {"message": "Hello from ParallelOpticalController GetTopology!", "context_id": context_id, "topology_id": topology_id}, 200
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - AddLightpath endpoint with JSON body approach and storage
@optical.route('/AddLightpath')
@optical.response(200, 'Success')
@optical.response(404, 'Error, not found')
class AddLightpath(Resource):
    @staticmethod
    def post():
        """
        [CHAFI-PARALLEL-OPTICAL] Compute lightpath using custom RSA algorithm.
        Receives all data via JSON body from ServiceService.
        Stores the lightpath in db_flows (similar to opticalcontroller).

        JSON Body:
            src: Source device name
            dst: Destination device name
            src_index: Source endpoint index (e.g., "TP1_11")
            dst_index: Destination endpoint index (e.g., "TP2_11")
            bitrate: Required bandwidth in Gbps
            bidir: Bidirectionality flag (0=unidirectional, 1=bidirectional)
            constraint_type: Service type (e.g., "flexi_grid")
        """
        global flow_counter, db_flows

        # [CHAFI-PARALLEL-OPTICAL] Parse JSON body
        data = request.get_json() or {}

        src = data.get("src", "unknown")
        dst = data.get("dst", "unknown")
        src_index = data.get("src_index", "")
        dst_index = data.get("dst_index", "")
        bitrate = data.get("bitrate", 100)
        bidir = data.get("bidir", 0)
        constraint_type = data.get("constraint_type", "flexi_grid")
        # [CHAFI-PARALLEL-OPTICAL] Extract service_uuid
        service_uuid = data.get("service_uuid", "")
        # [CHAFI-THESIS] Extract additional_hops (0 = use default in topology.py)
        additional_hops = data.get("additional_hops", 0)

        # [CHAFI-THESIS] Generate flow ID (auto-increment like opticalcontroller)
        flow_counter += 1
        flow_id = flow_counter

        # [CHAFI-THESIS] Store lightpath in db_flows (structure matches opticalcontroller)
        # Status options: PLANNED (initial), ACTIVE (RSA success), FAILED (RSA failed)
        db_flows[flow_id] = {
            "flow_id": flow_id,
            # [CHAFI-PARALLEL-OPTICAL] Store service_uuid
            "service_uuid": service_uuid,
            "src": src,
            "dst": dst,
            "src_index": src_index,
            "dst_index": dst_index,
            "bitrate": bitrate,
            "bidir": bidir,
            "constraint_type": constraint_type,
            "additional_hops": additional_hops,  # [CHAFI-THESIS] Dynamic hop limit
            # RSA results (placeholder - TODO: implement custom RSA)
            "op-mode": 0,  # 0 = pending, 1 = success, -1 = failed
            "slots": [],
            "path": [],
            "band": 0,
            "freq": 0,
            "n_slots": 0,
            "status": "PLANNED",  # PLANNED | ACTIVE | FAILED
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }

        # LOGGER.info("[CHAFI-RSA] AddLightpath: flow_id={} | {}:{} -> {}:{} | {}Gbps".format(
        #     flow_id, src, src_index, dst, dst_index, bitrate))

        return db_flows[flow_id], 200
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - GetLightpaths endpoint to retrieve all stored lightpaths
@optical.route('/GetLightpaths')
@optical.response(200, 'Success')
@optical.response(404, 'Error, not found')
class GetLightpaths(Resource):
    @staticmethod
    def get():
        """
        [CHAFI-PARALLEL-OPTICAL] Get all stored lightpaths.
        Returns db_flows dictionary (same format as opticalcontroller).
        """
        # LOGGER.info(
        #     "[CHAFI-RSA] GetLightpaths: {} flows".format(len(db_flows)))
        try:
            return db_flows, 200
        except Exception as e:
            LOGGER.error("[CHAFI-RSA] GetLightpaths error: {}".format(e))
            return {"error": str(e)}, 404
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - GetLightpath endpoint to retrieve a specific lightpath by ID
@optical.route('/GetLightpath/<int:flow_id>')
@optical.response(200, 'Success')
@optical.response(404, 'Error, not found')
class GetLightpath(Resource):
    @staticmethod
    def get(flow_id):
        """
        [CHAFI-PARALLEL-OPTICAL] Get a specific lightpath by flow ID.
        """
        if flow_id in db_flows:
            # LOGGER.info("[CHAFI-RSA] GetLightpath: flow_id={}".format(flow_id))
            return db_flows[flow_id], 200
        else:
            LOGGER.warning(
                "[CHAFI-RSA] GetLightpath: flow_id={} not found".format(flow_id))
            return {"error": "flow_id {} not found".format(flow_id)}, 404
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - PerformRSA endpoint
# This endpoint receives lightpath parameters and performs RSA computation
@optical.route('/PerformRSA/<int:flow_id>')
@optical.response(200, 'Success')
@optical.response(404, 'Error, not found')
class PerformRSA(Resource):
    @staticmethod
    def get(flow_id):
        """
        [CHAFI-PARALLEL-OPTICAL] Perform RSA computation for a specific lightpath.
        Receives flow_id and retrieves parameters from db_flows.

        Parameters retrieved:
            - src: Source device name
            - dst: Destination device name  
            - src_index: Source endpoint index
            - dst_index: Destination endpoint index
            - bitrate: Required bandwidth in Gbps
            - constraint_type: Service type (e.g., flexi_grid)
        """
        start_time = time.time()
        LOGGER.info("[CHAFI-CRASH-DEBUG] PerformRSA START flow_id={}".format(flow_id))
        # [CHAFI-THESIS] Validate flow_id exists in db_flows
        if flow_id not in db_flows:
            LOGGER.warning(
                "[CHAFI-RSA] PerformRSA: flow_id={} not found".format(flow_id))
            return {"error": "flow_id {} not found".format(flow_id), "success": False}, 404

        # [CHAFI-THESIS] Retrieve lightpath parameters
        lightpath = db_flows[flow_id]
        src = lightpath.get("src", "unknown")
        dst = lightpath.get("dst", "unknown")
        src_index = lightpath.get("src_index", "")
        dst_index = lightpath.get("dst_index", "")
        bitrate = lightpath.get("bitrate", 0)
        bidir = lightpath.get("bidir", 0)
        constraint_type = lightpath.get("constraint_type", "flexi_grid")
        additional_hops = lightpath.get("additional_hops", 0)
        status = lightpath.get("status", "PLANNED")

        # LOGGER.info("[CHAFI-RSA] PerformRSA: flow_id={} | {}:{} -> {}:{} | {}Gbps".format(
        #     flow_id, src, src_index, dst, dst_index, bitrate))

        # [CHAFI-THESIS] Step 1: Calculate required bandwidth and slots
        LOGGER.info("[CHAFI-CRASH-DEBUG] Step 1: bandwidth calculation")
        t_step1_start = time.time()
        bandwidth_result = get_required_bandwidth(
            bitrate=bitrate,
            modulation=DEFAULT_MODULATION,
            roll_off_factor=DEFAULT_ROLL_OFF_FACTOR
        )
        t_step1 = time.time() - t_step1_start

        # [CHAFI-THESIS] Step 2: Fetch optical devices once (to avoid duplicate queries)
        LOGGER.info("[CHAFI-CRASH-DEBUG] Step 2: fetching optical devices")
        t_step2_start = time.time()
        OPTICAL_DEVICE_TYPES = {
            DeviceTypeEnum.OPTICAL_ROADM.value,
            DeviceTypeEnum.EMULATED_OPTICAL_ROADM.value,
            DeviceTypeEnum.OPEN_ROADM.value,
            DeviceTypeEnum.EMULATED_OPEN_ROADM.value,
            DeviceTypeEnum.OPTICAL_TRANSPONDER.value,
            DeviceTypeEnum.EMULATED_OPTICAL_TRANSPONDER.value,
        }

        try:
            ctx_client = ContextClient()
            ctx_client.connect()
            device_list = ctx_client.ListDevices(Empty())
            all_devices = list(device_list.devices)
            optical_devices = [
                d for d in all_devices if d.device_type in OPTICAL_DEVICE_TYPES]
            ctx_client.close()
        except Exception as e:
            LOGGER.error(f"[CHAFI-RSA] Device fetch error: {e}")
            optical_devices = []
        t_step2 = time.time() - t_step2_start

        # [CHAFI-THESIS] Step 3a: Fetch optical links from context (DB-dependent)
        LOGGER.info("[CHAFI-CRASH-DEBUG] Step 3a: fetching optical links from context")
        t_step3a_start = time.time()
        try:
            optical_links_json = fetch_optical_links_for_rsa(optical_devices)
        except Exception as e:
            LOGGER.error("[CHAFI-RSA] Fetch links error: {}".format(e))
            optical_links_json = []
        t_step3a = time.time() - t_step3a_start

        # [CHAFI-THESIS] Step 3b: Build NetworkX graph (pure computation)
        LOGGER.info("[CHAFI-CRASH-DEBUG] Step 3b: building graph from pre-fetched data")
        t_step3b_start = time.time()
        try:
            G, _ = build_graph(directed=False, optical_devices=optical_devices, optical_links=optical_links_json)
            graph_nodes = list(G.nodes(data=True))
            graph_edges = list(G.edges(data=True, keys=True))

            graph_info = {
                "nodes_count": len(graph_nodes),
                "edges_count": len(graph_edges),
                "nodes": [{"name": n, "type": a.get('type'), "category": a.get('category')}
                          for n, a in graph_nodes],
                "edges": [{"src": src, "dst": dst, "name": a.get('name'),
                           "transport_type": a.get('transport_type'), "used": a.get('used')}
                          for src, dst, key, a in graph_edges]
            }
        except Exception as e:
            LOGGER.error("[CHAFI-RSA] Graph error: {}".format(e))
            graph_info = {"error": str(e), "nodes_count": 0, "edges_count": 0}
        t_step3b = time.time() - t_step3b_start

        # [CHAFI-THESIS] Step 5: Find all paths between source and destination
        LOGGER.info("[CHAFI-CRASH-DEBUG] Step 5: find_paths START")
        paths_info = {"dijkstra": [], "all_paths": [], "error": None}
        paths_timing = {}
        try:
            paths_result = find_paths(src, src_index, dst, dst_index, G, additional_hops=additional_hops)
            paths_info = {
                "dijkstra": paths_result.get('dijkstra', []),
                "all_paths": paths_result.get('all_paths', []),
                "error": paths_result.get('error')
            }
            paths_timing = paths_result.get('timing', {})
            LOGGER.info("[CHAFI-CRASH-DEBUG] Step 5: find_paths DONE | dijkstra={} all_paths={}".format(
                len(paths_info['dijkstra']), len(paths_info['all_paths'])))
        except Exception as e:
            LOGGER.error("[CHAFI-RSA] Path finding error: {}".format(e))
            paths_info['error'] = str(e)

        # [CHAFI-THESIS] Step 6: Perform RSA on dijkstra path
        LOGGER.info("[CHAFI-CRASH-DEBUG] Step 6: RSA on dijkstra path")
        rsa_result = {"success": False, "error": None}
        t_rsa_start = time.time()
        try:
            # why the cache?
            #   during the RSA computation we are gonna use endpoint details, channel information,etc frequently. Since querying the database is a heavy task and in this context it is unnecessary, we just built a cache until the computation. The data remains in memory and finally the bitmap_value is updated.
            cache = OpticalLinksCache(optical_links_json)

            if paths_info.get('dijkstra') and len(paths_info['dijkstra']) > 0:
                dijkstra_path = paths_info['dijkstra'][0]

                result = TopologyHelper.perform_rsa(
                    path_obj=dijkstra_path,
                    bandwidth=bandwidth_result['required_slots_ceil'] *
                    bandwidth_result['slot_granularity_ghz'],
                    cache=cache
                )

                # Check if perform_rsa returned None
                if result is not None:
                    rsa_result = result
                else:
                    rsa_result['error'] = "perform_rsa returned None"
            else:
                rsa_result['error'] = "No dijkstra path found"

        except Exception as e:
            LOGGER.error("[CHAFI-RSA] RSA error: {}".format(e))
            rsa_result = {"success": False, "error": str(e)}
        t_rsa_end = time.time()

        # [CHAFI-THESIS] Store computed data in db_flows for additional path RSA
        LOGGER.info("[CHAFI-CRASH-DEBUG] Step 7: storing results in db_flows")
        # Note: We don't store bandwidth_calculation - it's recalculated from bitrate to ensure consistency
        db_flows[flow_id]['computed_paths'] = paths_info
        db_flows[flow_id]['optical_links'] = optical_links_json

        # [CHAFI-RSA-SLOT] Persist RSA result (containing acquisition metadata)
        if 'dijkstra_rsa_result' not in db_flows[flow_id]:
            db_flows[flow_id]['dijkstra_rsa_result'] = {}
        db_flows[flow_id]['dijkstra_rsa_result'] = rsa_result
        # LOGGER.info("[CHAFI-RSA-SLOT] Stored dijkstra_rsa_result in db")

        # LOGGER.debug(
        #     "[CHAFI-RSA] Stored paths and optical_links in db_flows[{}]".format(flow_id))

        # Log final result
        # if rsa_result.get('success'):
        #     LOGGER.info("[CHAFI-RSA] Result: SUCCESS slots {}-{}".format(
        #         rsa_result.get('start_slot'), rsa_result.get('end_slot')))
        # else:
        #     LOGGER.warning(
        #         "[CHAFI-RSA] Result: FAILED - {}".format(rsa_result.get('error')))

        # [CHAFI-THESIS] Return parameters with bandwidth calculation, graph info, paths, and RSA result
        # [CHAFI-THESIS] Return parameters with bandwidth calculation, graph info, paths, and RSA result
        elapsed_time = time.time() - start_time
        # LOGGER.info("[CHAFI-POC: PerformRSA] PerformRSA completed in {:.4f} seconds".format(elapsed_time))

        # [CHAFI-TIMING] Performance timing summary (per-step breakdown)
        t_dijkstra = paths_timing.get('dijkstra_sec', 0)
        t_allpaths = paths_timing.get('all_paths_sec', 0)
        t_rsa = t_rsa_end - t_rsa_start
        t_fetch_total = t_step2 + t_step3a  # all DB/gRPC overhead
        t_compute_total = t_step1 + t_step3b + t_dijkstra + t_rsa + t_allpaths  # pure computation
        LOGGER.info(
            "[CHAFI-TIMING] PerformRSA flow_id={} | "
            "FETCH[devices: {:.4f}s, links: {:.4f}s] = {:.4f}s | "
            "COMPUTE[graph: {:.4f}s, dijkstra: {:.4f}s, rsa: {:.4f}s, alt_paths: {:.4f}s] = {:.4f}s | "
            "TOTAL: {:.4f}s".format(
                flow_id,
                t_step2, t_step3a, t_fetch_total,
                t_step3b, t_dijkstra, t_rsa, t_allpaths, t_compute_total,
                elapsed_time)
        )

        return {
            "success": True,
            "message": "RSA computation completed",
            "flow_id": flow_id,
            "parameters": {
                "src": src,
                "dst": dst,
                "src_index": src_index,
                "dst_index": dst_index,
                "bitrate": bitrate,
                "bidir": bidir,
                "constraint_type": constraint_type
            },
            "bandwidth_calculation": {
                "modulation": bandwidth_result['modulation'],
                "symbols_m": bandwidth_result['symbols_m'],
                "bits_per_symbol": bandwidth_result['bits_per_symbol'],
                "roll_off_factor": bandwidth_result['roll_off_factor'],
                "nyquist_bandwidth_ghz": bandwidth_result['nyquist_bandwidth'],
                "slot_granularity_ghz": bandwidth_result['slot_granularity_ghz'],
                "required_slots_exact": bandwidth_result['required_slots'],
                "required_slots": bandwidth_result['required_slots_ceil']
            },
            "topology_graph": graph_info,
            "paths": paths_info,
            "rsa_result": rsa_result,
            "rsa_result": rsa_result,
            "status": status,
            "acquired_path_type": lightpath.get("acquired_path_type"),
            "acquired_path_links": PerformRSA._get_acquired_path_links(lightpath),
            "elapsed_time": elapsed_time
        }, 200

    @staticmethod
    def _get_acquired_path_links(lightpath):
        """Return the acquired path links stored at acquisition time."""
        return lightpath.get("acquired_path_links")
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - DeleteLightpath endpoint
@optical.route('/PerformAdditionalPathRSA/<int:flow_id>/<int:path_index>')
@optical.response(200, 'Success')
@optical.response(404, 'Error, not found')
class PerformAdditionalPathRSA(Resource):
    @staticmethod
    def get(flow_id, path_index):
        """
        [CHAFI-PARALLEL-OPTICAL] Perform RSA on an alternative path.

        Uses stored data from main PerformRSA to avoid re-computation:
        - Retrieves path from db_flows['computed_paths']['all_paths'][path_index]
        - Reuses optical_links and bandwidth_calculation
        - Performs RSA using TopologyHelper.perform_rsa()

        Args:
            flow_id: Flow identifier
            path_index: Index in all_paths list (0-based)
        """
        # [CHAFI-THESIS] Validate flow_id exists
        if flow_id not in db_flows:
            LOGGER.warning(
                "[CHAFI-RSA] AdditionalPathRSA: flow_id={} not found".format(flow_id))
            return {"error": "flow_id {} not found".format(flow_id), "success": False}, 404

        # [CHAFI-THESIS] Check if computed data exists
        if 'computed_paths' not in db_flows[flow_id] or 'optical_links' not in db_flows[flow_id]:
            LOGGER.warning(
                "[CHAFI-RSA] AdditionalPathRSA: flow_id={} missing computed data. Run main PerformRSA first.".format(flow_id))
            return {
                "error": "Computed paths not found. Please run main RSA first.",
                "success": False
            }, 404

        # [CHAFI-THESIS] Retrieve stored data
        computed_paths = db_flows[flow_id]['computed_paths']
        optical_links = db_flows[flow_id]['optical_links']
        lightpath = db_flows[flow_id]

        # [CHAFI-THESIS] Recalculate bandwidth from source bitrate (ensures consistency with main RSA)
        bitrate = lightpath.get('bitrate', 0)
        bandwidth_calc = get_required_bandwidth(
            bitrate=bitrate,
            modulation=DEFAULT_MODULATION,
            roll_off_factor=DEFAULT_ROLL_OFF_FACTOR
        )

        # [CHAFI-THESIS] Validate path_index
        all_paths = computed_paths.get('all_paths', [])
        if path_index < 0 or path_index >= len(all_paths):
            LOGGER.warning(
                "[CHAFI-RSA] AdditionalPathRSA: Invalid path_index={} (total paths: {})".format(
                    path_index, len(all_paths)))
            return {
                "error": "Invalid path index. Available: 0-{}".format(len(all_paths) - 1),
                "success": False
            }, 404

        # [CHAFI-THESIS] Get the selected path
        path_obj = all_paths[path_index]

        # LOGGER.info(
        #     "[CHAFI-RSA] AdditionalPathRSA: flow_id={} path_index={} | {}:{} -> {}:{}".format(
        #         flow_id, path_index,
        #         lightpath.get('src'), lightpath.get('src_index'),
        #         lightpath.get('dst'), lightpath.get('dst_index')))

        # [CHAFI-THESIS] Perform RSA using stored data
        rsa_result = {"success": False, "error": None}
        try:
            # Build transient cache from stored optical_links
            cache = OpticalLinksCache(optical_links)

            # Calculate bandwidth (reuse from stored calculation)
            bandwidth_gbps = bandwidth_calc['required_slots_ceil'] * \
                bandwidth_calc['slot_granularity_ghz']

            # Perform RSA on selected path
            result = TopologyHelper.perform_rsa(
                path_obj=path_obj,
                bandwidth=bandwidth_gbps,
                cache=cache
            )

            if result is not None:
                rsa_result = result
            else:
                rsa_result['error'] = "perform_rsa returned None"

        except Exception as e:
            LOGGER.error("[CHAFI-RSA] AdditionalPathRSA error: {}".format(e))
            rsa_result = {"success": False, "error": str(e)}

        # [CHAFI-RSA-SLOT] Persist RSA result (containing acquisition metadata)
        # We key it by the path index so we can retrieve it later
        result_key = f"alternative_{path_index}_rsa_result"
        db_flows[flow_id][result_key] = rsa_result
        # LOGGER.info(f"[CHAFI-RSA-SLOT] Stored {result_key} in db")

        # Log result
        # if rsa_result.get('success'):
        #     LOGGER.info("[CHAFI-RSA] AdditionalPath Result: SUCCESS slots {}-{}".format(
        #         rsa_result.get('start_slot'), rsa_result.get('end_slot')))
        # else:
        #     LOGGER.warning(
        #         "[CHAFI-RSA] AdditionalPath Result: FAILED - {}".format(rsa_result.get('error')))

        # [CHAFI-THESIS] Return RSA result with path info
        # Format bandwidth_calculation to match PerformRSA structure
        return {
            "success": True,
            "flow_id": flow_id,
            "path_index": path_index,
            "path_obj": path_obj,
            "parameters": {
                "src": lightpath.get('src'),
                "dst": lightpath.get('dst'),
                "src_index": lightpath.get('src_index'),
                "dst_index": lightpath.get('dst_index'),
                "bitrate": lightpath.get('bitrate')
            },
            "bandwidth_calculation": {
                "modulation": bandwidth_calc['modulation'],
                "symbols_m": bandwidth_calc['symbols_m'],
                "bits_per_symbol": bandwidth_calc['bits_per_symbol'],
                "roll_off_factor": bandwidth_calc['roll_off_factor'],
                "nyquist_bandwidth_ghz": bandwidth_calc['nyquist_bandwidth'],
                "slot_granularity_ghz": bandwidth_calc['slot_granularity_ghz'],
                "required_slots_exact": bandwidth_calc['required_slots'],
                "required_slots": bandwidth_calc['required_slots_ceil']
            },
            "rsa_result": rsa_result,
            "status": lightpath.get("status", "PLANNED"),
            "acquired_path_type": lightpath.get("acquired_path_type")
        }, 200
# [CHAFI-THESIS-END]


@optical.route('/DeleteLightpath/<int:flow_id>')
@optical.response(200, 'Success')
@optical.response(404, 'Error, not found')
class DeleteLightpath(Resource):
    @staticmethod
    def delete(flow_id):
        """
        [CHAFI-PARALLEL-OPTICAL] Delete a lightpath by flow ID.
        Sets status to FAILED (soft delete).
        """
        if flow_id in db_flows:
            db_flows[flow_id]["status"] = "FAILED"
            # LOGGER.info(
        #     "[CHAFI-RSA] DeleteLightpath: flow_id={} marked FAILED".format(flow_id))
            return {"message": "Lightpath {} deleted".format(flow_id), "flow": db_flows[flow_id]}, 200
        else:
            LOGGER.warning(
                "[CHAFI-RSA] DeleteLightpath: flow_id={} not found".format(flow_id))
            return {"error": "flow_id {} not found".format(flow_id)}, 404
# [CHAFI-THESIS-END]


# [CHAFI-THESIS-START] - Acquire Slots Endpoint
@optical.route('/AcquireSlots/<int:flow_id>', '/AcquireSlots/<int:flow_id>/<int:path_index>')
@optical.response(200, 'Success')
@optical.response(207, 'Partial Success')
@optical.response(400, 'Bad Request')
@optical.response(404, 'Not Found')
class AcquireSlots(Resource):
    def get(self, flow_id, path_index=None):
        """
        Trigger the acquisition of slots for a specific path.
        GET request usually comes from the browser directly or simple API calls.
        """
        # LOGGER.info(f"[POC:AcquireSlots] GET request: flow_id={flow_id}, path_index={path_index}")
        return self._process_acquisition(flow_id, path_index)

    def _process_acquisition(self, flow_id, path_index):
        start_time = time.time()
        if flow_id not in db_flows:
            return {"error": f"flow_id {flow_id} not found"}, 404

        flow_data = db_flows[flow_id]

        # 1. Retrieve the correct RSA result based on path selection
        if path_index is None:
            # Dijkstra path
            rsa_result = flow_data.get('dijkstra_rsa_result')
            path_type = "dijkstra"
        else:
            # Alternative path
            result_key = f"alternative_{path_index}_rsa_result"
            rsa_result = flow_data.get(result_key)
            path_type = f"alternative_{path_index}"

        if not rsa_result:
            return {"error": f"No RSA result found for {path_type} flow {flow_id}"}, 404

        if not rsa_result.get('success'):
            return {"error": "Cannot acquire slots for a failed RSA result"}, 400

        # 2. Extract acquisition metadata and allocation info
        acquisition_metadata = rsa_result.get('acquisition_metadata', [])
        start_slot = rsa_result.get('start_slot')
        num_slots = rsa_result.get('num_slots')
        reference_slots = rsa_result.get('reference_slots', 0)

        if not acquisition_metadata:
            return {"error": "No acquisition metadata found. Re-run RSA."}, 400

        # LOGGER.info(f"[POC:AcquireSlots] Starting acquisition for {path_type}: {len(acquisition_metadata)} endpoints to update")

        # 3. Connect to Context Service
        # 3. Connect to Context Service
        # Imports moved to top
        context_client = ContextClient()  # Assuming default connection params

        updated_endpoints = []
        errors = []

        try:
            # Imports moved to top

            for meta in acquisition_metadata:
                try:
                    endpoint_name = meta['endpoint_name']
                    device_uuid = meta['device_uuid']
                    device_type = meta['device_type']
                    aligned_bitmap_str = meta['aligned_bitmap']
                    offset_slots = meta['offset_slots']
                    native_flex_slots = meta['native_flex_slots']

                    # 3a. Apply allocation mask to aligned bitmap (Set slots to 0)
                    # Convert string to list for mutability
                    aligned_bits = list(aligned_bitmap_str)

                    for i in range(num_slots):
                        # The slot index in reference frame (0..N-1)
                        slot_idx = start_slot + i

                        # Convert to string index (MSB first string)
                        string_idx = reference_slots - 1 - slot_idx

                        if 0 <= string_idx < len(aligned_bits):
                            aligned_bits[string_idx] = '0'

                    # 3b. Extract native portion
                    modified_aligned_str = "".join(aligned_bits)

                    # Convert modified aligned string back to full integer
                    full_bitmap_int = int(modified_aligned_str, 2)

                    # Shift right by offset to drop lower frequency padding
                    shifted_int = full_bitmap_int >> offset_slots

                    # Mask to keep only native width
                    native_mask = (1 << native_flex_slots) - 1
                    native_bitmap_int = shifted_int & native_mask

                    native_bitmap_str = str(native_bitmap_int)

                    # 3c. Fetch current config to map Endpoint to Channel
                    opticalconfig_id = OpticalConfigId()
                    opticalconfig_id.opticalconfig_uuid = opticalconfig_uuid_get_duuid(
                        device_uuid)
                    current_config_obj = context_client.SelectOpticalConfig(
                        opticalconfig_id)

                    if not current_config_obj or not current_config_obj.config:
                        raise Exception(
                            f"Could not fetch config for device {device_uuid}")

                    # Parse config safely
                    current_config = json.loads(current_config_obj.config) if isinstance(
                        current_config_obj.config, str) else current_config_obj.config

                    target_channel_name = None

                    # [CHAFI-RSA-SLOT] Improved Channel Lookup (Sync with RSATools)
                    if device_type in [DeviceTypeEnum.OPTICAL_TRANSPONDER.value, DeviceTypeEnum.EMULATED_OPTICAL_TRANSPONDER.value]:
                        # Transponder: Match by endpoint_index (from metadata)
                        endpoint_index = meta.get('endpoint_index')

                        if endpoint_index:
                            # 1. Map endpoint_index -> channel_name using config['endpoints']
                            # config['endpoints'] list of dicts: {'endpoint_uuid': {'index': '1', 'channel': 'channel-0'}, ...}
                            mapped_channel_name = None
                            for ep in current_config.get('endpoints', []):
                                ep_uuid = ep.get('endpoint_uuid', {})
                                if str(ep_uuid.get('index')) == str(endpoint_index):
                                    mapped_channel_name = ep_uuid.get(
                                        'channel')
                                    break

                            if mapped_channel_name:
                                # 2. Validate channel exists in config['channels']
                                for ch in current_config.get('channels', []):
                                    ch_name = ch.get('name', {})
                                    # channel name index matches mapped channel name
                                    if ch_name.get('index') == mapped_channel_name:
                                        target_channel_name = mapped_channel_name
                                        break

                        if not target_channel_name:
                            LOGGER.warning(
                                f"[POC:AcquireSlots] Could not find channel for TR endpoint_index {endpoint_index}, trying name {endpoint_name}")
                            # Fallback to name map if index logic failed
                            # ... (could implement name fallback here if needed)

                    elif device_type in [DeviceTypeEnum.OPTICAL_ROADM.value, DeviceTypeEnum.EMULATED_OPTICAL_ROADM.value,
                                         DeviceTypeEnum.OPEN_ROADM.value, DeviceTypeEnum.EMULATED_OPEN_ROADM.value]:
                        # ROADM: Match by endpoint.name (channel_index == endpoint_name)
                        for channel in current_config.get('channels', []):
                            ch_index = channel.get('channel_index')
                            if not ch_index and isinstance(channel.get('name'), dict):
                                ch_index = channel['name'].get('index')

                            if str(ch_index) == str(endpoint_name):
                                target_channel_name = ch_index
                                break

                    if not target_channel_name:
                        # Fallback or Error
                        LOGGER.error(
                            f"[POC:AcquireSlots] Failed. DeviceType={device_type}, Name={endpoint_name}, Index={meta.get('endpoint_index')}")
                        raise Exception(
                            f"Could not find channel for endpoint {endpoint_name}")

                    # LOGGER.info(f"[CHAFI-RSA-SLOT-NEW-BITMAP] Device={device_type} Endpoint={endpoint_name} NativeBitmap={native_bitmap_str} FlexSlots={native_flex_slots}")

                    # 3d. Construct Update Payload
                    # [CHAFI-RSA-SLOT] Must include ALL mandatory fields (type, channel_namespace, endpoints)
                    # because Context Service uses UPSERT (INSERT keys ... ON CONFLICT UPDATE)
                    # [CHAFI-RSA-SLOT] Retrieve existing channel data to preserve state
                    existing_channel_data = {}
                    if 'channels' in current_config:
                        for ch in current_config['channels']:
                            # Check match by name/index
                            ch_idx = ch.get('name', {}).get('index') if isinstance(
                                ch.get('name'), dict) else ch.get('name')
                            if not ch_idx and 'channel_index' in ch:
                                ch_idx = ch['channel_index']

                            if str(ch_idx) == str(target_channel_name):
                                existing_channel_data = ch
                                break

                    update_payload = {
                        "new_config": {
                            "type": current_config.get('type'),
                            "channel_namespace": current_config.get('channel_namespace'),
                            "endpoints": current_config.get('endpoints', []),
                            "channels": [
                                {
                                    "name": {"index": target_channel_name},
                                    "bitmap_value": native_bitmap_str,
                                    "flex_slots": native_flex_slots,
                                    # Preserve existing values or default to 0 if not found
                                    "frequency": existing_channel_data.get("frequency", 0),
                                    "operational-mode": existing_channel_data.get("operational-mode", 0),
                                    "target-output-power": existing_channel_data.get("target-output-power", ""),
                                    "status": existing_channel_data.get("status", ""),
                                    # [CHAFI-RSA-SLOT] Preserve Transponder frequency bounds
                                    "min_frequency": existing_channel_data.get("min_frequency", 0),
                                    "max_frequency": existing_channel_data.get("max_frequency", 0),
                                    # [CHAFI-RSA-SLOT] Preserve ROADM specific fields
                                    "lower_frequency": int(existing_channel_data["lower_frequency"]) if "lower_frequency" in existing_channel_data else 0,
                                    "upper_frequency": int(existing_channel_data["upper_frequency"]) if "upper_frequency" in existing_channel_data else 0,
                                    "dest_port": existing_channel_data.get("dest_port"),
                                    "src_port": existing_channel_data.get("src_port"),
                                    "band_name": existing_channel_data.get("band_name"),
                                    "type": existing_channel_data.get("type", "media_channel"),
                                }
                            ]
                        }
                    }

                    config_update = OpticalConfig()
                    config_update.opticalconfig_id.CopyFrom(opticalconfig_id)
                    # Start of Fix for gRPC Error: ensure device_id is set
                    if hasattr(current_config_obj, 'device_id'):
                        config_update.device_id.CopyFrom(
                            current_config_obj.device_id)
                    # End of Fix
                    config_update.config = json.dumps(update_payload)

                    # 3e. Perform Update
                    context_client.UpdateOpticalConfig(config_update)

                    # LOGGER.info(f"[POC:AcquireSlots] Updated {endpoint_name} (Channel {target_channel_name}): {native_bitmap_str}")
                    updated_endpoints.append({
                        "device": device_uuid,
                        "endpoint": endpoint_name,
                        "channel": target_channel_name,
                        "new_bitmap": native_bitmap_str
                    })

                except Exception as ex:
                    LOGGER.error(
                        f"[POC:AcquireSlots] Error updating endpoint {meta.get('endpoint_name')}: {ex}")
                    errors.append(str(ex))

            if errors:
                return {"status": "partial_success", "updated": updated_endpoints, "errors": errors}, 207

            # [CHAFI-RSA-SLOT] Step 4: Update OpticalLink status to 'used'
            path_links = rsa_result.get('links', [])
            # LOGGER.info(f"[LINKMARK-DEBUG] ===== STEP 4: Marking links in DB =====")
            # LOGGER.info(f"[LINKMARK-DEBUG] flow_id={flow_id}, path_index={path_index}, path_type={path_type}")
            # LOGGER.info(f"[LINKMARK-DEBUG] rsa_result has {len(path_links)} links to mark")
            for link_item in path_links:
                try:
                    # 1. Get current link
                    # Imports moved to top
                    link_id = LinkId()

                    # Check if link_item is a dict (from db_flows) or string (uuid)
                    if isinstance(link_item, dict):
                        # Extract UUID from 'id' field
                        target_uuid = link_item.get('id')
                        link_name = link_item.get('name', 'N/A')
                        link_src = link_item.get('src', 'N/A')
                        link_dst = link_item.get('dst', 'N/A')
                        link_src_port = link_item.get('src_port', 'N/A')
                        link_dst_port = link_item.get('dst_port', 'N/A')
                        # LOGGER.info(f"[LINKMARK-DEBUG] Link: {link_name} | {link_src}:{link_src_port} -> {link_dst}:{link_dst_port} | uuid={target_uuid}")
                        if not target_uuid:
                            LOGGER.warning(
                                f"[POC:AcquireSlots] Link dict missing 'id': {link_item}")
                            continue
                    else:
                        # Assume it's a UUID string
                        target_uuid = str(link_item)
                        # LOGGER.info(f"[LINKMARK-DEBUG] Link UUID (string): {target_uuid}")

                    link_id.link_uuid.uuid = target_uuid
                    optical_link = context_client.GetOpticalLink(link_id)

                    # 2. Update used status
                    # The OpticalLink message structure (common.proto.context_pb2)
                    # usually has optical_details inside.
                    if hasattr(optical_link, 'optical_details'):
                        optical_link.optical_details.used = True
                        context_client.SetOpticalLink(optical_link)
                        # LOGGER.info(f"[LINKMARK-DEBUG] DB UPDATED: link {target_uuid} marked used=True")
                    else:
                        LOGGER.warning(
                            f"[POC:AcquireSlots] Link {target_uuid} has no optical_details")

                except Exception as link_ex:
                    LOGGER.error(
                        f"[POC:AcquireSlots] Error updating link {target_uuid}: {link_ex}")
                    # We don't fail the whole request for a link update failure, but we log it

            # [CHAFI-RSA-SLOT] Step 5: Update cached computed_paths to reflect used status
            # LOGGER.info(f"[LINKMARK-DEBUG] ===== STEP 5: Updating in-memory cache =====")
            try:
                used_link_uuids = set()
                for link_item in path_links:
                    if isinstance(link_item, dict):
                        used_link_uuids.add(link_item.get('id'))
                    else:
                        used_link_uuids.add(str(link_item))

                # LOGGER.info(f"[LINKMARK-DEBUG] used_link_uuids to mark in cache: {used_link_uuids}")

                if 'computed_paths' in db_flows[flow_id]:
                    def update_path_list(path_list, list_name):
                        for path_idx, path in enumerate(path_list):
                            path_invalidated = False
                            for link in path.get('links', []):
                                link_id_in_path = link.get('id')
                                if link_id_in_path in used_link_uuids:
                                    link['used'] = True
                                    link['status'] = 'USED'
                                    path_invalidated = True
                                    # LOGGER.info(f"[LINKMARK-DEBUG] CACHE MATCH: {list_name}[{path_idx}] link {link.get('name')} (uuid={link_id_in_path}) marked USED")

                            if path_invalidated:
                                path['is_valid'] = False

                    update_path_list(db_flows[flow_id]['computed_paths'].get(
                        'all_paths', []), 'all_paths')
                    update_path_list(db_flows[flow_id]['computed_paths'].get(
                        'dijkstra', []), 'dijkstra')
                    # LOGGER.info(f"[POC:AcquireSlots] Updated cached paths for flow {flow_id} to reflect used links")

            except Exception as cache_ex:
                LOGGER.warning(
                    f"[POC:AcquireSlots] Error updating cached paths: {cache_ex}")

            # [CHAFI-RSA-SLOT] Step 6: Update Service Status to ACTIVE
            try:
                service_uuid = db_flows[flow_id].get('service_uuid')
                if service_uuid:
                    # Helper to update service status
                    # Imports moved to top

                    ctx_client = ContextClient()
                    ctx_client.connect()
                    try:
                        # 1. Create ServiceId
                        # We assume default context for now or extract from somewhere if needed
                        # But GetService requires ServiceId which needs ContextId
                        # ParallelOpticalTools uses DEFAULT_CONTEXT_NAME
                        # Let's try to construct it.
                        c_id = ContextId()
                        c_id.context_uuid.uuid = "admin"  # DEFAULT_CONTEXT_NAME
                        s_id = ServiceId()
                        s_id.context_id.CopyFrom(c_id)
                        s_id.service_uuid.uuid = service_uuid

                        # 2. Get Service
                        svc = ctx_client.GetService(s_id)

                        # 3. Update Status
                        svc.service_status.service_status = ServiceStatusEnum.SERVICESTATUS_ACTIVE

                        # 4. Set Service (Update)
                        ctx_client.SetService(svc)
                        # LOGGER.info(f"[POC:AcquireSlots] Updated Service {service_uuid} status to ACTIVE")
                    except Exception as e:
                        LOGGER.error(
                            f"[POC:AcquireSlots] Failed to update service status: {e}")
                    finally:
                        ctx_client.close()
                else:
                    LOGGER.warning(
                        f"[POC:AcquireSlots] No service_uuid found for flow {flow_id}, skipping status update")
            except Exception as svc_ex:
                LOGGER.error(
                    f"[POC:AcquireSlots] Error during service status update: {svc_ex}")

            # [CHAFI-RSA-SLOT] Step 7: Mark Flow as ACTIVE
            db_flows[flow_id]['status'] = 'ACTIVE'
            db_flows[flow_id]['acquired_path_type'] = path_type
            # [CHAFI-THESIS] Store acquired path links for display
            computed = flow_data.get('computed_paths', {})
            if path_type == "dijkstra":
                dijkstra = computed.get('dijkstra', [])
                db_flows[flow_id]['acquired_path_links'] = dijkstra[0].get('links', []) if dijkstra else []
            elif path_index is not None:
                all_paths = computed.get('all_paths', [])
                db_flows[flow_id]['acquired_path_links'] = all_paths[path_index].get('links', []) if path_index < len(all_paths) else []

            elapsed_time = time.time() - start_time
            # LOGGER.info(f"[POC:AcquireSlots] Flow {flow_id} status updated to ACTIVE (Path: {path_type}). Total time: {elapsed_time:.4f} seconds")

            return {"status": "success", "updated": updated_endpoints, "flow_status": "ACTIVE", "elapsed_time": elapsed_time}, 200

        except Exception as e:
            LOGGER.error(f"[POC:AcquireSlots] Context connection error: {e}")
            LOGGER.error(traceback.format_exc())
            return {"error": str(e)}, 500


if __name__ == '__main__':
    # LOGGER.info("Starting Parallel Optical Controller on port 10075...")
    app.run(host='0.0.0.0', port=10075, debug=False)
