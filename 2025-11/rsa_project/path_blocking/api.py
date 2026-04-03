import sys
from pathlib import Path
import logging
from flask import Flask, request, jsonify

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# Add the parent directory to python path to access models, topology, etc.
current_dir = Path(__file__).resolve().parent
parent_dir = current_dir.parent
sys.path.append(str(parent_dir))

from app import app as rsa_app
import time
import json
from models import db, Lightpath
from topology import find_paths
from helpers import TopologyHelper

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

    if not src_device or not dst_device or not bitrate:
        return jsonify({"status": "error", "reason": "Missing required fields: src_device, dst_device, bitrate"}), 400

    try:
        bitrate = int(bitrate)
    except ValueError:
        return jsonify({"status": "error", "reason": "Bitrate must be an integer"}), 400

    # Execute within the existing RSA app context to connect to DB
    with rsa_app.app_context():
        # Start timer for pure computation (excluding DB store)
        start_time = time.time()

        # 1. Path Computation & RSA internally combined in find_paths
        paths_result = find_paths(src_device, None, dst_device, None, bitrate, dijkstra_only=True)
        
        dijkstra_paths = paths_result.get('dijkstra', [])
        if not dijkstra_paths:
            # Graph couldn't even connect the two nodes physically via free links
            return jsonify({"status": "path-blocked", "reason": "No valid route found"}), 200

        selected_path = dijkstra_paths[0]
        link_names = [link.get('name') for link in selected_path.get('links', [])]
        logger.info(f"[API] Selected Dijkstra physical path received: {link_names}")
        
        rsa_res = selected_path.get('rsa_result')

        # 2. Check if slots were available
        if not rsa_res or not rsa_res.get('success'):
            return jsonify({"status": "path-blocked", "reason": "No spectrum available"}), 200

        # 3. Acquire slots
        link_ids = [link['id'] for link in selected_path.get('links', [])]
        final_bitmap_int = rsa_res.get('final_bitmap_int')

        success = TopologyHelper.commit_slots(link_ids, final_bitmap_int)

        # End timer: algorithm + slot assignment is complete, stopping before Lightpath store
        computation_time_s = time.time() - start_time

        if success:
            # 4. Save to Lightpath tracking table
            new_lp = Lightpath(
                src_device=src_device,
                dst_device=dst_device,
                bitrate=bitrate,
                link_ids=json.dumps(link_ids),
                allocated_mask=str(rsa_res.get('mask'))
            )
            db.session.add(new_lp)
            db.session.commit()

            return jsonify({
                "status": "success",
                "lightpath_id": str(new_lp.id),
                "computation_time_s": computation_time_s,
                "allocated_mask": final_bitmap_int,
                "start_slot": rsa_res.get('start_slot'),
                "num_slots": rsa_res.get('num_slots'),
                "links": link_ids
            }), 200
        else:
            return jsonify({"status": "error", "reason": "Failed to commit slots to database"}), 500

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

if __name__ == '__main__':
    # Run slightly offset from the main GUI (e.g., port 5001)
    api_app.run(debug=True, host='0.0.0.0', port=5001)
