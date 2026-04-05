import sys
from pathlib import Path

# Add parent directory to path for imports when running from path_blocking/
sys.path.insert(0, str(Path(__file__).parent.parent))

from helpers import TopologyHelper
from topology import find_paths
from models import db, Lightpath
import json
import time
from app import app as rsa_app
import logging
from flask import Flask, request, jsonify

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# Add the parent directory to python path to access models, topology, etc.
current_dir = Path(__file__).resolve().parent
parent_dir = current_dir.parent
sys.path.append(str(parent_dir))


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
        MAX_RETRIES = 5
        retry_count = 0
        collision_count = 0

        while retry_count < MAX_RETRIES:
            start_time = time.time()

            # 1. Path Computation & RSA internally combined in find_paths
            # We re-query the DB every time to get the latest spectrum state
            paths_result = find_paths(
                src_device, dst_device, bitrate, dijkstra_only=True)

            dijkstra_paths = paths_result.get('dijkstra', [])
            if not dijkstra_paths:
                # Graph couldn't even connect the two nodes physically via free links
                return jsonify({
                    "status": "path-blocked",
                    "reason": "No valid route found",
                    "retries": retry_count,
                    "collisions": collision_count
                }), 200

            selected_path = dijkstra_paths[0]
            rsa_res = selected_path.get('rsa_result')

            # 2. Check if slots were available
            if not rsa_res or not rsa_res.get('success'):
                return jsonify({
                    "status": "path-blocked",
                    "reason": "No spectrum available",
                    "retries": retry_count,
                    "collisions": collision_count
                }), 200

            # 3. Acquire slots with pessimistic locking
            link_ids = [link['id'] for link in selected_path.get('links', [])]
            mask = rsa_res.get('mask')

            result = TopologyHelper.commit_slots(link_ids, mask)

            if result == True:
                # Success!
                computation_time_s = time.time() - start_time

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
                    "allocated_mask": mask,
                    "start_slot": rsa_res.get('start_slot'),
                    "num_slots": rsa_res.get('num_slots'),
                    "links": link_ids,
                    "retries": retry_count,
                    "collisions": collision_count
                }), 200

            elif result == "collision":
                # A race condition occurred. "Send it back to initial phase"
                retry_count += 1
                collision_count += 1
                logger.info(
                    f"[API] Collision detected for {src_device}->{dst_device}. Retrying {retry_count}/{MAX_RETRIES}")
                continue
            elif result == "full_endpoint":
                # An OCH or OMS endpoint became FULL between RSA and commit
                retry_count += 1
                logger.info(
                    f"[API] Full endpoint detected for {src_device}->{dst_device}. Retrying {retry_count}/{MAX_RETRIES}")
                continue
            else:
                return jsonify({"status": "error", "reason": "System error during slot commitment"}), 500

        # If we reached here, we hit MAX_RETRIES due to collisions
        return jsonify({
            "status": "path-blocked",
            "reason": "Persistent resource contention (Max retries reached)",
            "retries": retry_count,
            "collisions": collision_count
        }), 200


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
