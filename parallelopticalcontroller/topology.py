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
# Topology Module for Parallel Optical Controller
# This module handles network graph building and path finding using NetworkX
# Similar to thesis/rsa_project/topology.py but adapted for TeraFlowSDN context
# [CHAFI-THESIS-END]

import logging
import time
import networkx as nx
from typing import Dict, List, Tuple, Optional, Any

# [CHAFI-THESIS-START] - TeraFlowSDN Context Client for querying devices and links
from context.client.ContextClient import ContextClient
from common.proto.context_pb2 import Empty, TopologyId
from common.DeviceTypes import DeviceTypeEnum
from common.Constants import TransportTypeEnum, get_standardized_transport_type
# [CHAFI-THESIS-END]

# Configure logging
logging.basicConfig(level=logging.INFO)
LOGGER = logging.getLogger(__name__)


# =============================================================================
# [CHAFI-THESIS] OPTICAL DEVICE TYPES - Client-side filtering
# =============================================================================
# We only consider these device types for our NetworkX graph.
# Other devices (routers, switches, etc.) are not part of the optical topology.
# =============================================================================
OPTICAL_DEVICE_TYPES = {
    # ROADMs (Reconfigurable Optical Add-Drop Multiplexers)
    DeviceTypeEnum.OPTICAL_ROADM.value,           # 'optical-roadm'
    DeviceTypeEnum.EMULATED_OPTICAL_ROADM.value,  # 'emu-optical-roadm'
    DeviceTypeEnum.OPEN_ROADM.value,              # 'openroadm'
    DeviceTypeEnum.EMULATED_OPEN_ROADM.value,     # 'emu-optical-openroadm'
    # Transponders
    DeviceTypeEnum.OPTICAL_TRANSPONDER.value,           # 'optical-transponder'
    DeviceTypeEnum.EMULATED_OPTICAL_TRANSPONDER.value,  # 'emu-optical-transponder'
}


# =============================================================================
# [CHAFI-THESIS] DATA STRUCTURES COMPARISON
# =============================================================================
# rsa_project (SQLAlchemy)      | TeraFlowSDN (gRPC/Protobuf)
# -----------------------------|------------------------------
# Devices.query.all()          | ctx_client.ListDevices(Empty())
#   - device.name              | device.device_id.device_uuid.uuid
#   - device.type              | device.device_type
#                              | device.device_endpoints[].endpoint_id
#                              |
# OpticalLink.query.all()      | ctx_client.GetOpticalLinkList(Empty())
#   - link.src_device.name     | link.optical_details.src_port (need to parse)
#   - link.dst_device.name     | link.optical_details.dst_port (need to parse)
#   - link.src_endpoint.name   | link.optical_details.src_port
#   - link.dst_endpoint.name   | link.optical_details.dst_port
#   - link.src_endpoint.otn_type | (need to determine from link properties)
#   - link.status              | link.optical_details.used (bool)
#   - link.name                | link.name
#   - link.id                  | link.link_id.link_uuid.uuid
# =============================================================================


def get_context_client() -> ContextClient:
    """
    [CHAFI-THESIS] Create and return a ContextClient instance.
    This is our gateway to query TeraFlowSDN's context service.
    """
    ctx_client = ContextClient()
    ctx_client.connect()
    return ctx_client


def fetch_devices(ctx_client: ContextClient) -> List[Any]:
    """
    [CHAFI-THESIS] Fetch all devices from TeraFlowSDN context.

    Returns:
        List of Device protobuf objects
    """
    device_list = ctx_client.ListDevices(Empty())
    devices = list(device_list.devices)
    # LOGGER.debug(f"[CHAFI-TOPOLOGY] Fetched {len(devices)} devices")
    return devices


def fetch_optical_devices(ctx_client: ContextClient) -> List[Any]:
    """
    [CHAFI-THESIS] Fetch ONLY optical devices from TeraFlowSDN context.

    Filters devices by type to include only:
    - OPTICAL_ROADM / EMULATED_OPTICAL_ROADM
    - OPEN_ROADM / EMULATED_OPEN_ROADM
    - OPTICAL_TRANSPONDER / EMULATED_OPTICAL_TRANSPONDER

    Non-optical devices (routers, switches, etc.) are excluded.

    Returns:
        List of Device protobuf objects (filtered to optical types only)
    """
    all_devices = fetch_devices(ctx_client)
    optical_devices = [
        d for d in all_devices if d.device_type in OPTICAL_DEVICE_TYPES]
    # LOGGER.info(
    # f"[CHAFI-TOPOLOGY] Optical devices: {len(optical_devices)}/{len
    # (all_devices)} (filtered)")
    # LOGGER.debug(
    #    f"[CHAFI-TOPOLOGY] Included: {[d.name for d in optical_devices]}")
    return optical_devices


def fetch_optical_links(ctx_client: ContextClient) -> List[Any]:
    """
    [CHAFI-THESIS] Fetch all optical links from TeraFlowSDN context.

    Returns:
        List of OpticalLink protobuf objects
    """
    optical_link_list = ctx_client.GetOpticalLinkList(Empty())
    links = list(optical_link_list.optical_links)
    # LOGGER.debug(f"[CHAFI-TOPOLOGY] Fetched {len(links)} optical links")
    return links


def fetch_optical_links_as_json() -> List[Dict]:
    """
    [CHAFI-THESIS] Fetch all optical links and return as JSON-serializable dict.

    This function queries optical links and converts the protobuf objects
    to a JSON-friendly format so we can inspect the data structure.

    Returns:
        List of dictionaries containing optical link data
    """

    ctx_client = get_context_client()
    links_json = []

    try:
        optical_links = fetch_optical_links(ctx_client)

        for link in optical_links:
            # Extract basic link info
            link_data = {
                "name": link.name,
                "link_id": link.link_id.link_uuid.uuid if link.link_id else None,
                "optical_details": {
                    "src_port": link.optical_details.src_port,
                    "dst_port": link.optical_details.dst_port,
                    "local_peer_port": link.optical_details.local_peer_port,
                    "remote_peer_port": link.optical_details.remote_peer_port,
                    "length": link.optical_details.length,
                    "used": link.optical_details.used,
                    "c_slots": dict(link.optical_details.c_slots),
                    "l_slots": dict(link.optical_details.l_slots),
                    "s_slots": dict(link.optical_details.s_slots),
                },
                "link_endpoint_ids": []
            }

            # Extract endpoint IDs (this tells us which devices the link connects)
            for ep_id in link.link_endpoint_ids:
                endpoint_data = {
                    "device_uuid": ep_id.device_id.device_uuid.uuid,
                    "endpoint_uuid": ep_id.endpoint_uuid.uuid,
                }
                link_data["link_endpoint_ids"].append(endpoint_data)

            links_json.append(link_data)

        # LOGGER.info(
        #    f"[CHAFI-TOPOLOGY] Links as JSON: {len(links_json)} processed")

    finally:
        ctx_client.close()

    return links_json


def fetch_optical_links_for_rsa(optical_devices: List[Any]) -> List[Dict]:
    """
    [CHAFI-THESIS] Fetch optical links for RSA with channel data enrichment.

    Args:
        optical_devices: List of optical device objects (pre-filtered)

    Returns:
        List of optical link dictionaries with endpoint channel data
    """
    from common.RSATools import fetch_channel_data_for_endpoint

    # LOGGER.info("[CHAFI-TOPOLOGY] Fetching optical links for RSA...")

    ctx_client = get_context_client()
    links_rsa = []

    try:
        # Step 1: Build device and endpoint lookup maps from pre-fetched optical devices
        device_map = {}  # device_uuid -> device name
        endpoint_map = {}  # endpoint_uuid -> basic endpoint info

        for device in optical_devices:
            device_uuid = device.device_id.device_uuid.uuid
            device_name = device.name if device.name else device_uuid
            device_type = device.device_type

            # Store device name for lookup
            device_map[device_uuid] = device_name

            # Build endpoint lookup from this device
            for ep in device.device_endpoints:
                ep_uuid = ep.endpoint_id.endpoint_uuid.uuid
                endpoint_map[ep_uuid] = {
                    'device_uuid': device_uuid,
                    'device_name': device_name,
                    'device_type': device_type,
                    'endpoint_name': ep.name,
                    'endpoint_index': getattr(ep, 'index', None),
                    'transport_type': getattr(ep, 'transport_type', None),
                }

        # LOGGER.debug(
        #     f"[CHAFI-TOPOLOGY] Lookup maps: {len(device_map)} devices, {len(endpoint_map)} endpoints")

        # Step 2: Fetch optical links and enrich with device/endpoint info + channel data
        optical_links = fetch_optical_links(ctx_client)

        for link in optical_links:
            # Build endpoints list with resolved names and channel data
            endpoints = []
            for ep_id in link.link_endpoint_ids:
                ep_uuid = ep_id.endpoint_uuid.uuid
                device_uuid = ep_id.device_id.device_uuid.uuid
                ep_info = endpoint_map.get(ep_uuid, {})

                # Build base endpoint info
                endpoint_data = {
                    'endpoint_uuid': ep_uuid,
                    'device_uuid': device_uuid,
                    'device_name': ep_info.get('device_name'),
                    'device_type': ep_info.get('device_type'),
                    'endpoint_index': ep_info.get('endpoint_index'),
                    'endpoint_name': ep_info.get('endpoint_name'),
                    'transport_type': ep_info.get('transport_type'),
                }

                # Fetch channel data for this endpoint
                device_type = ep_info.get('device_type')

                # Use endpoint_name for ROADM, endpoint_index for Transponder
                if device_type in ['optical-roadm', 'emu-optical-roadm', 'openroadm', 'emu-optical-openroadm']:
                    # ===> Refactor: should be verified that endpoint_name/s are not mixed and unified using the deviceuuid
                    endpoint_identifier = ep_info.get('endpoint_name')
                else:
                    endpoint_identifier = ep_info.get('endpoint_index')

                if device_uuid and endpoint_identifier:
                    channel_result = fetch_channel_data_for_endpoint(
                        device_uuid,
                        endpoint_identifier,
                        device_type,
                        ctx_client
                    )

                    if channel_result:
                        endpoint_data['channel_data'] = channel_result.get(
                            'channel_data')
                        endpoint_data['band_name'] = channel_result.get(
                            'band_name')
                        # LOGGER.debug(
                        #     f"[CHAFI-TOPOLOGY] Enriched endpoint: {ep_info.get('device_name')}:{endpoint_identifier}")

                endpoints.append(endpoint_data)

            # Include fields for RSA with channel_data
            link_data = {
                'link_uuid': link.link_id.link_uuid.uuid if link.link_id else None,
                'name': link.name,
                'src_port': link.optical_details.src_port,
                'dst_port': link.optical_details.dst_port,
                'used': link.optical_details.used,
                'endpoints': endpoints,
            }

            links_rsa.append(link_data)

        # LOGGER.info(
        #     f"[CHAFI-TOPOLOGY] RSA links fetched: {len(links_rsa)} with channel data enrichment")

    finally:
        ctx_client.close()

    return links_rsa


def build_graph(directed: bool = False, optical_devices: List[Any] = None, optical_links: List[Dict] = None) -> Tuple[nx.MultiGraph, List[Dict]]:
    # LOGGER.info("[CHAFI-TOPOLOGY] Building NetworkX graph...")

    # Create graph based on flag
    G = nx.MultiDiGraph() if directed else nx.MultiGraph()

    # Get context client
    ctx_client = get_context_client()

    try:
        # STEP 1: Fetch devices if not provided
        if optical_devices is None:
            # Fetch ALL devices and filter to optical devices
            all_devices = fetch_devices(ctx_client)
            optical_devices = [
                d for d in all_devices if d.device_type in OPTICAL_DEVICE_TYPES]
            # LOGGER.info(
            #     f"[CHAFI-TOPOLOGY] Optical devices: {len(optical_devices)}/{len(all_devices)} (filtered)")
        else:
            # Use pre-fetched optical devices
            # LOGGER.debug(
            #     f"[CHAFI-TOPOLOGY] Using pre-fetched optical devices: {len(optical_devices)}")
            pass

        # STEP 2: Add nodes (OPTICAL devices only)
        for device in optical_devices:
            # Use device.name if available, otherwise use UUID
            device_name = device.name if device.name else device.device_id.device_uuid.uuid
            device_uuid = device.device_id.device_uuid.uuid
            device_type = device.device_type

            # Categorize device type for display
            if device_type in {DeviceTypeEnum.OPTICAL_ROADM.value,
                               DeviceTypeEnum.EMULATED_OPTICAL_ROADM.value,
                               DeviceTypeEnum.OPEN_ROADM.value,
                               DeviceTypeEnum.EMULATED_OPEN_ROADM.value}:
                category = "ROADM"
            else:
                category = "TRANSPONDER"

            G.add_node(device_name,
                       type=device_type,
                       uuid=device_uuid,
                       category=category)

        # LOGGER.info(f"[CHAFI-TOPOLOGY] Graph nodes: {G.number_of_nodes()}")

        # STEP 3: Add edges (optical links)
        if optical_links is None:
            optical_links = fetch_optical_links_for_rsa(optical_devices)

        for link in optical_links:
            # Extract endpoints (should have exactly 2)
            endpoints = link.get('endpoints', [])
            if len(endpoints) < 2:
                LOGGER.warning(
                    f"[CHAFI-TOPOLOGY] Link {link['name']} has less than 2 endpoints, skipping")
                continue

            # Get source and destination device names
            src_device = endpoints[0].get('device_name')
            dst_device = endpoints[1].get('device_name')

            if not src_device or not dst_device:
                LOGGER.warning(
                    f"[CHAFI-TOPOLOGY] Link {link['name']} missing device names, skipping")
                continue

            # Check if both devices exist as nodes (only optical devices are in graph)
            if src_device not in G.nodes:
                # LOGGER.debug(
                #     f"[CHAFI-TOPOLOGY] Skipping link {link['name']}: src {src_device} not in graph")
                continue
            if dst_device not in G.nodes:
                # LOGGER.debug(
                #     f"[CHAFI-TOPOLOGY] Skipping link {link['name']}: dst {dst_device} not in graph")
                continue

            # Determine transport_type (similar to otn_type check in rsa_project)
            src_transport = endpoints[0].get('transport_type')
            dst_transport = endpoints[1].get('transport_type')

            if src_transport == dst_transport:
                transport_type = src_transport
            else:
                transport_type = "MIXED"
                LOGGER.warning(
                    f"[CHAFI-TOPOLOGY] Transport type mismatch on link {link['name']}: {src_transport} vs {dst_transport}")

            # Add edge with all attributes (mirrors rsa_project/topology.py)
            G.add_edge(
                src_device,
                dst_device,
                key=link['link_uuid'],
                name=link['name'],
                transport_type=transport_type,
                original_src=src_device,
                original_dst=dst_device,
                src_port=endpoints[0].get('endpoint_name'),
                dst_port=endpoints[1].get('endpoint_name'),
                src_index=endpoints[0].get('endpoint_index'),
                dst_index=endpoints[1].get('endpoint_index'),
                used=link.get('used', False),
                capacity=100  # Default capacity
            )

        # LOGGER.info(f"[CHAFI-TOPOLOGY] Graph edges: {G.number_of_edges()}")

    finally:
        ctx_client.close()

    return G, optical_links


# =============================================================================
# [CHAFI-THESIS] PATH FINDING FUNCTIONS
# =============================================================================
# Adapted from thesis/rsa_project/topology.py:find_paths()
# and thesis/rsa_project/helpers.py:TopologyHelper.expand_path()
# =============================================================================

def find_paths(src_device: str, src_index: str, dst_device: str, dst_index: str, G: nx.MultiGraph = None, additional_hops: int = 0) -> Dict:
    """
    [CHAFI-THESIS] Find all paths between source and destination devices.

    This function mirrors thesis/rsa_project/topology.py:find_paths()
    adapted for TeraFlowSDN context.

    Args:
        src_device: Source device name
        src_index: Source endpoint index (e.g., 'TP1_11', can be None to allow any)
        dst_device: Destination device name
        dst_index: Destination endpoint index (e.g., 'TP2_11', can be None to allow any)
        G: Optional pre-built graph. If None, builds a new graph.
        additional_hops: Allowed additional hops beyond dijkstra shortest path (0 = use default)

    Returns:
        Dictionary with:
        - dijkstra: List of shortest paths (FREE links only)
        - all_paths: List of all simple paths with parallel link combinations
    """
    DEFAULT_ADDITIONAL_HOPS = 1
    shortest_path_hops = None  # set after dijkstra succeeds

    LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths START | {}:{} -> {}:{} | additional_hops={}".format(
        src_device, src_index, dst_device, dst_index, additional_hops if additional_hops > 0 else DEFAULT_ADDITIONAL_HOPS))

    # LOGGER.info(
    #     f"[CHAFI-TOPOLOGY] Finding paths: {src_device}:{src_index} -> {dst_device}:{dst_index}")

    # Build graph if not provided
    if G is None:
        G, _ = build_graph(directed=False)

    # LOGGER.debug(
    #     f"[CHAFI-TOPOLOGY] Graph: {G.number_of_nodes()} nodes, {G.number_of_edges()} edges")

    paths_result = {
        'dijkstra': [],
        'all_paths': [],
        'error': None
    }

    # Check if source and destination exist in graph
    if src_device not in G.nodes:
        paths_result['error'] = f"Source device '{src_device}' not found in graph"
        LOGGER.error(f"[CHAFI-TOPOLOGY] {paths_result['error']}")
        return paths_result

    if dst_device not in G.nodes:
        paths_result['error'] = f"Destination device '{dst_device}' not found in graph"
        LOGGER.error(f"[CHAFI-TOPOLOGY] {paths_result['error']}")
        return paths_result

    # --- 1. Dijkstra Shortest Path (FREE links only) ---
    # OCH links MUST be FREE (cannot be shared), OMS links can be shared
    LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: building G_free for dijkstra")
    t_dijkstra_start = time.time()
    G_free = nx.MultiGraph()
    G_free.add_nodes_from(G.nodes(data=True))

    for u, v, k, d in G.edges(keys=True, data=True):
        transport = d.get('transport_type', '')
        used = d.get('used', False)

        # Use get_standardized_transport_type from common/Constants.py
        standardized = get_standardized_transport_type(transport)

        if standardized == 'OCH' and not used:
            G_free.add_edge(u, v, key=k, **d)
        # OMS links can be shared unless they are FULL
        elif standardized == 'OMS':
            G_free.add_edge(u, v, key=k, **d)
        # MIXED or other types - add if FREE
        elif not used:
            G_free.add_edge(u, v, key=k, **d)

    # LOGGER.debug(f"[CHAFI-TOPOLOGY] G_free: {G_free.number_of_edges()} edges")

    # Convert to simple graph for Dijkstra (unique device pairs)
    G_simple_free = nx.Graph(G_free)
    LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: G_free={} edges, G_simple_free={} edges | running dijkstra".format(
        G_free.number_of_edges(), G_simple_free.number_of_edges()))

    try:
        dijkstra_node_path = nx.shortest_path(
            G_simple_free, source=src_device, target=dst_device)
        # [CHAFI-THESIS] Store dijkstra hop count for dynamic cutoff
        shortest_path_hops = len(dijkstra_node_path) - 1
        # LOGGER.info(f"[CHAFI-TOPOLOGY] Dijkstra path: {dijkstra_node_path}")

        # Expand using G_free to ensure we only pick FREE links
        # ====> Refactor: is this necessary?
        d_edge_paths = expand_path(
            dijkstra_node_path, G_free, src_index, dst_index)
        # LOGGER.debug(
        #     f"[CHAFI-TOPOLOGY] Expanded to {len(d_edge_paths)} physical paths")

        # User requested ONLY ONE path for Dijkstra, even if parallel links exist
        selected_path = d_edge_paths[:1]

        if selected_path:
            paths_result['dijkstra'] = selected_path

    except nx.NetworkXNoPath:
        pass  # No Dijkstra path on FREE graph

    t_dijkstra_end = time.time()
    LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: dijkstra DONE in {:.4f}s | found {} paths".format(
        t_dijkstra_end - t_dijkstra_start, len(paths_result['dijkstra'])))

    # --- 2. All Simple Paths (Include USED) ---
    # [CHAFI-THESIS] Dynamic cutoff: dijkstra hops + allowed additional hops
    t_allpaths_start = time.time()

    if shortest_path_hops is not None:
        effective_additional_hops = additional_hops if additional_hops > 0 else DEFAULT_ADDITIONAL_HOPS
        HIGHEST_HOP = shortest_path_hops + effective_additional_hops
        LOGGER.info("[CHAFI-CRASH-DEBUG] Dynamic cutoff: dijkstra_hops={} + additional={} = {}".format(
            shortest_path_hops, effective_additional_hops, HIGHEST_HOP))

        G_simple = nx.Graph(G)
        LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: all_paths START | G has {} edges, G_simple has {} edges".format(
            G.number_of_edges(), G_simple.number_of_edges()))

        try:
            simple_node_paths = list(nx.all_simple_paths(
                G_simple, source=src_device, target=dst_device, cutoff=HIGHEST_HOP))
            LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: found {} node sequences".format(
                len(simple_node_paths)))

            total_edge_paths = 0
            for i, node_path in enumerate(simple_node_paths):
                # LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: expanding node_path {}/{} = {} | total_valid_so_far={}".format(
                #     i+1, len(simple_node_paths), node_path, total_edge_paths))
                first_valid = expand_path_first_valid(node_path, G, None, None)
                if first_valid:
                    paths_result['all_paths'].append(first_valid)
                    total_edge_paths += 1
                LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: node_path {}/{} result={}".format(
                    i+1, len(simple_node_paths), "VALID" if first_valid else "no valid path"))

        except nx.NetworkXNoPath:
            pass  # No simple paths found
    else:
        LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: skipping all_paths (no dijkstra path found)")

    t_allpaths_end = time.time()
    LOGGER.info("[CHAFI-CRASH-DEBUG] find_paths: all_paths DONE in {:.4f}s | total_valid={}".format(
        t_allpaths_end - t_allpaths_start, len(paths_result['all_paths'])))

    # Store timing data in result
    paths_result['timing'] = {
        'dijkstra_sec': t_dijkstra_end - t_dijkstra_start,
        'all_paths_sec': t_allpaths_end - t_allpaths_start,
    }

    return paths_result


def expand_path(node_path: List[str], graph_to_use: nx.MultiGraph, src_index: str, dst_index: str) -> List[Dict]:
    """
    [CHAFI-THESIS] Converts a node path (list of device names) into detailed link paths.
    Handles parallel links and port constraints.

    Mirrors thesis/rsa_project/helpers.py:TopologyHelper.expand_path()

    Args:
        node_path: List of device names (e.g., ['TP1', 'RDM1', 'TP2'])
        graph_to_use: NetworkX MultiGraph with edge data
        src_index: Source endpoint index constraint (e.g., 'TP1_11', can be None)
        dst_index: Destination endpoint index constraint (e.g., 'TP2_11', can be None)

    Returns:
        List of path dictionaries, each with 'links' and 'is_valid' keys
    """
    valid_edge_paths = []

    def backtrack(index, current_edge_path):
        if index == len(node_path) - 1:
            # Reached destination - check path validity
            # Path Validity Logic (mirrors rsa_project):
            # - OCH links MUST be FREE (they cannot be shared)
            # - OMS links can be shared unless FULL
            is_valid = True
            for link in current_edge_path:
                transport = link.get('transport_type', '')
                used = link.get('used', False)

                standardized = get_standardized_transport_type(transport)

                # [CHAFI-DEBUG] Log transport type for debugging
                # LOGGER.debug(
                #     f"[CHAFI-TOPOLOGY: expand_path] Link {link.get('name')} | Type: {transport} -> {standardized} | Used: {used}")

                # OCH links must be FREE. Treat NA (unknown) as OCH for safety.
                # Compare against Enum members, not strings
                if (standardized == TransportTypeEnum.OCH or standardized == TransportTypeEnum.NA) and used:
                    is_valid = False
                    break
                # For OMS, we'd check for FULL status, but we only have 'used'
                # OMS can be shared, so 'used' doesn't invalidate the path

            valid_edge_paths.append({
                'links': list(current_edge_path),
                'is_valid': is_valid,
                'node_path': node_path,
                'hops': len(current_edge_path)
            })
            return

        u = node_path[index]
        v = node_path[index + 1]

        # Find all edges between u and v in the specified graph
        if not graph_to_use.has_edge(u, v):
            # LOGGER.debug(
            #     f"[CHAFI-TOPOLOGY] expand_path: No edge between {u} and {v}")
            return

        edges = graph_to_use[u][v]  # dict of key -> attributes

        for key, attr in edges.items():
            # Determine ports based on direction (mirrors rsa_project)
            original_src = attr.get('original_src')
            original_dst = attr.get('original_dst')

            if original_src == u and original_dst == v:
                out_port = attr.get('src_port')
                in_port = attr.get('dst_port')
                out_idx = attr.get('src_index')
                in_idx = attr.get('dst_index')
            elif original_src == v and original_dst == u:
                out_port = attr.get('dst_port')
                in_port = attr.get('src_port')
                out_idx = attr.get('dst_index')
                in_idx = attr.get('src_index')
            else:
                # LOGGER.debug(
                #     f"[CHAFI-TOPOLOGY] expand_path: Edge {key} direction mismatch")
                continue

            # Check endpoint index constraints (exact match)
            # First hop: must match src_index if specified
            if index == 0 and src_index and out_idx != src_index:
                # LOGGER.debug(
                #     f"[CHAFI-TOPOLOGY] expand_path: First hop index mismatch: {src_index} vs {out_idx}")
                continue

            # Last hop: must match dst_index if specified
            if index == len(node_path) - 2 and dst_index and in_idx != dst_index:
                # LOGGER.debug(
                #     f"[CHAFI-TOPOLOGY] expand_path: Last hop index mismatch: {dst_index} vs {in_idx}")
                continue

            # Add link to current path
            current_edge_path.append({
                'id': str(key),
                'src': u,
                'dst': v,
                'src_port': out_port,
                'dst_port': in_port,
                'name': attr.get('name'),
                'transport_type': attr.get('transport_type'),
                'used': attr.get('used', False),
                'status': 'USED' if attr.get('used', False) else 'FREE'
            })

            backtrack(index + 1, current_edge_path)
            current_edge_path.pop()

    backtrack(0, [])
    return valid_edge_paths


def expand_path_first_valid(node_path: List[str], graph_to_use: nx.MultiGraph, src_index: str, dst_index: str) -> Dict:
    """
    [CHAFI-THESIS] Plan A: One valid path per node sequence.
    Same backtracking logic as expand_path but stops at the FIRST valid path found.
    Used for alternative paths to avoid combinatorial explosion with parallel links.

    Args:
        node_path: List of device names (e.g., ['TP1', 'RDM1', 'TP2'])
        graph_to_use: NetworkX MultiGraph with edge data
        src_index: Source endpoint index constraint (can be None to skip)
        dst_index: Destination endpoint index constraint (can be None to skip)

    Returns:
        Single path dict with 'links', 'is_valid', 'node_path', 'hops' — or None
    """
    result = [None]  # mutable container for closure

    def backtrack(index, current_edge_path):
        if result[0] is not None:
            return

        if index == len(node_path) - 1:
            is_valid = True
            for link in current_edge_path:
                transport = link.get('transport_type', '')
                used = link.get('used', False)
                standardized = get_standardized_transport_type(transport)
                if (standardized == TransportTypeEnum.OCH or standardized == TransportTypeEnum.NA) and used:
                    is_valid = False
                    break

            if is_valid:
                result[0] = {
                    'links': list(current_edge_path),
                    'is_valid': True,
                    'node_path': node_path,
                    'hops': len(current_edge_path)
                }
            return

        u = node_path[index]
        v = node_path[index + 1]

        if not graph_to_use.has_edge(u, v):
            return

        edges = graph_to_use[u][v]

        for key, attr in edges.items():
            if result[0] is not None:
                return

            original_src = attr.get('original_src')
            original_dst = attr.get('original_dst')

            if original_src == u and original_dst == v:
                out_port = attr.get('src_port')
                in_port = attr.get('dst_port')
                out_idx = attr.get('src_index')
                in_idx = attr.get('dst_index')
            elif original_src == v and original_dst == u:
                out_port = attr.get('dst_port')
                in_port = attr.get('src_port')
                out_idx = attr.get('dst_index')
                in_idx = attr.get('src_index')
            else:
                continue

            if index == 0 and src_index and out_idx != src_index:
                continue

            if index == len(node_path) - 2 and dst_index and in_idx != dst_index:
                continue

            current_edge_path.append({
                'id': str(key),
                'src': u,
                'dst': v,
                'src_port': out_port,
                'dst_port': in_port,
                'name': attr.get('name'),
                'transport_type': attr.get('transport_type'),
                'used': attr.get('used', False),
                'status': 'USED' if attr.get('used', False) else 'FREE'
            })

            backtrack(index + 1, current_edge_path)
            current_edge_path.pop()

    backtrack(0, [])
    return result[0]


def _parse_link_name(link_name: str) -> Tuple[str, str, str, str]:
    """
    [CHAFI-THESIS] Parse link name to extract source/destination device and port names.

    Link name format: "DEVICE1:PORT1->DEVICE2:PORT2"
    Example: "RDM1:4102->TP2:11" -> ("RDM1", "TP2", "4102", "11")

    Args:
        link_name: Full link name string

    Returns:
        Tuple of (src_device, dst_device, src_port, dst_port)
        Returns (None, None, None, None) if parsing fails
    """
    try:
        # Split by "->" to get source and destination parts
        if "->" not in link_name:
            LOGGER.warning(
                f"[CHAFI-TOPOLOGY] Link name missing '->': {link_name}")
            return (None, None, None, None)

        src_part, dst_part = link_name.split("->")

        # Split each part by ":" to get device and port
        if ":" not in src_part or ":" not in dst_part:
            LOGGER.warning(
                f"[CHAFI-TOPOLOGY] Link name missing ':': {link_name}")
            return (None, None, None, None)

        src_device, src_port = src_part.split(":", 1)
        dst_device, dst_port = dst_part.split(":", 1)

        # LOGGER.debug(
        #     f"[CHAFI-TOPOLOGY] Parsed link '{link_name}': {src_device}:{src_port} -> {dst_device}:{dst_port}")

        return (src_device, dst_device, src_port, dst_port)

    except Exception as e:
        LOGGER.error(
            f"[CHAFI-TOPOLOGY] Error parsing link name '{link_name}': {e}")
        return (None, None, None, None)

# [unused and must be refactored in future]


def _extract_device_from_port(port_identifier: str) -> str:
    """
    [CHAFI-THESIS] Extract device name from port identifier.

    TeraFlowSDN endpoints are typically formatted as "device_name/port_name"
    or similar patterns. This function extracts the device name portion.

    Args:
        port_identifier: Full port/endpoint identifier string

    Returns:
        Device name extracted from the identifier
    """
    # TODO: [CHAFI-THESIS] Verify actual format from TeraFlowSDN
    # Common patterns:
    # - "device_name/port_name" -> split on "/"
    # - "device_name:port_name" -> split on ":"
    # - UUID format -> may need lookup

    if "/" in port_identifier:
        return port_identifier.split("/")[0]
    elif ":" in port_identifier:
        return port_identifier.split(":")[0]
    else:
        # Return as-is if no delimiter found
        return port_identifier
