# isort: skip_file
from pathlib import Path
import json
import time
import logging
from flask import Flask, request, jsonify
from app import app as rsa_app
from models import db, Lightpath
from topology import find_paths
from helpers import TopologyHelper
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))


# Add parent directory to path for imports when running from path_blocking/
logging.basicConfig(level=logging.WARNING)
logger = logging.getLogger(__name__)

# Create a lightweight Flask app for the API server
api_app = Flask(__name__)


@api_app.route('/api/lightpath/request', methods=['POST'])
def request_lightpath():
    data = request.get_json()
    if not data:
        return jsonify({"status": "error", "reason": "Invalid JSON"}), 400

    src_device = data.get('src_device')
    dst_device = data.get('dst_device')
    bitrate = data.get('bitrate')
    path_strategy = data.get('path_strategy', 'first-fit')
    spectrum_strategy = data.get('spectrum_strategy', 'first-fit')
    path_type = data.get('path_type', 'both')
    parallelpath_strategy = data.get('parallelpath_strategy', 'none')

    if not src_device or not dst_device or not bitrate:
        return jsonify({"status": "error", "reason": "Missing required fields: src_device, dst_device, bitrate"}), 400

    try:
        bitrate = int(bitrate)
    except ValueError:
        return jsonify({"status": "error", "reason": "Bitrate must be an integer"}), 400

    # Execute within the existing RSA app context to connect to DB
    with rsa_app.app_context():

        start_graph_time = time.time()
        # 1. Path Computation — returns ordered list [dijkstra, alt]
        paths_result = find_paths(src_device, dst_device, bitrate, strategy=path_strategy, path_type=path_type, parallelpath_strategy=parallelpath_strategy)
        graph_build_time = time.time() - start_graph_time
        graph_gen_ms = paths_result.get('graph_gen_ms', 0)
        # logger.info(f"[Timing] Time to build graphs: {graph_build_time:.4f} seconds")
        paths = paths_result.get('paths', [])
        blocked_reason = paths_result.get('blocked_reason')

        # Collect only the timing keys that were actually computed this call
        path_timings = {}
        for key in ('dijkstra_path_ms', 'dijkstra_parallel_ms',
                    'additional_path_ms', 'additional_parallel_ms'):
            val = paths_result.get(key)
            if val is not None:
                path_timings[key] = val

        if not paths:
            # No physically usable path exists (all OCH dead or disconnected)
            return jsonify({
                "status": "path-blocked",
                "reason": blocked_reason or "no_path",
                "path_strategy": path_strategy,
                "spectrum_strategy": spectrum_strategy,
                "graph_gen_ms": graph_gen_ms,
                **path_timings
            }), 200

        # 2. Try RSA on each path in order (dijkstra first, alt second)
        selected_path = None
        rsa_res = None
        rsa_ms = 0
        start_rsa_time = time.time()
        for path in paths:
            rsa = TopologyHelper.perform_rsa(path, bitrate, spectrum_strategy)
            if rsa:
                rsa_ms = rsa.get('rsa_ms', 0)
                if rsa.get('success'):
                    selected_path = path
                    rsa_res = rsa
                    break
        rsa_time = time.time() - start_rsa_time
        # logger.info(f"[Timing] Time to perform RSA: {rsa_time:.4f} seconds")

        if not selected_path:
            # Paths exist but no contiguous spectrum on any of them
            return jsonify({
                "status": "spectral-blocked",
                "reason": "No contiguous spectrum available on any candidate path",
                "paths_tried": len(paths),
                "path_strategy": path_strategy,
                "spectrum_strategy": spectrum_strategy,
                "graph_gen_ms": graph_gen_ms,
                "rsa_ms": rsa_ms,
                **path_timings
            }), 200

        link_ids = [link['id'] for link in selected_path.get('links', [])]
        mask = rsa_res.get('mask')

        start_commit_time = time.time()
        result = TopologyHelper.commit_slots(rsa_res.get('endpoints', []), mask)
        commit_time = time.time() - start_commit_time
        # logger.info(f"[Timing] Time to commit slots: {commit_time:.4f} seconds")

        if result == True:
            # Success!
            computation_time_s = graph_build_time+rsa_time+commit_time

            # 4. Save to Lightpath tracking table
            new_lp = Lightpath(
                src_device=src_device,
                dst_device=dst_device,
                bitrate=bitrate,
                link_ids=json.dumps(link_ids),
                allocated_mask=str(mask)
            )
            db.session.add(new_lp)
            db.session.commit()

            return jsonify({
                "status": "success",
                "lightpath_id": str(new_lp.id),
                "computation_time_s": computation_time_s,
                "graph_gen_ms": graph_gen_ms,
                "rsa_ms": rsa_ms,
                **path_timings,
                "allocated_mask": mask,
                "start_slot": rsa_res.get('start_slot'),
                "num_slots": rsa_res.get('num_slots'),
                "links": link_ids
            }), 200
        else:
            return jsonify({"status": "error", "reason": "System error during slot commitment"}), 500



@api_app.route('/api/lightpath/teardown', methods=['POST'])
def teardown_lightpath():
    data = request.get_json()
    if not data:
        return jsonify({"status": "error", "reason": "Invalid JSON"}), 400

    lightpath_id = data.get('lightpath_id')
    if not lightpath_id:
        return jsonify({"status": "error", "reason": "Missing lightpath_id"}), 400

    with rsa_app.app_context():
        # 1. Look up the lightpath
        lp = Lightpath.query.get(lightpath_id)
        if not lp:
            return jsonify({"status": "error", "reason": "Lightpath not found"}), 404

        link_ids = json.loads(lp.link_ids)
        allocated_mask = lp.allocated_mask

        # 2. Release slots in topology (Record time spent freeing)
        td_start = time.time()
        success = TopologyHelper.free_slots(link_ids, allocated_mask)
        teardown_time_s = time.time() - td_start

        if success:
            # 3. Delete from DB
            db.session.delete(lp)
            db.session.commit()
            return jsonify({
                "status": "success",
                "message": "Lightpath torn down successfully",
                "teardown_time_s": teardown_time_s
            }), 200
        else:
            return jsonify({"status": "error", "reason": "Failed to free slots"}), 500


@api_app.route('/api/topology/links', methods=['GET'])
def get_link_mapping():
    from models import OpticalLink
    with rsa_app.app_context():
        links = OpticalLink.query.all()
        mapping = {str(link.id): link.name for link in links}
    return jsonify(mapping), 200


if __name__ == '__main__':
    # Run slightly offset from the main GUI (e.g., port 5001)
    api_app.run(debug=True, host='0.0.0.0', port=5001)
