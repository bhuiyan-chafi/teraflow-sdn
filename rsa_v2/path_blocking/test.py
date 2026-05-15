# python3 test.py request --src RDMny --dst RDMtx --bitrate 100 --path_strategy highest-slot --spectrum_strategy first-fit --path_type dijkstra --parallelpath_strategy highest-slot
# python3 test.py teardown --id YOUR_LIGHTPATH_ID_HERE

import requests
import json
import argparse
import sys

API_URL = "http://127.0.0.1:5001/api/lightpath/request"
TEARDOWN_URL = "http://127.0.0.1:5001/api/lightpath/teardown"


def test_request(src, dst, bitrate, path_strategy='first-fit', spectrum_strategy='first-fit', path_type='dijkstra', parallelpath_strategy='none'):
    payload = {
        "src_device": src,
        "dst_device": dst,
        "bitrate": bitrate,
        "path_strategy": path_strategy,
        "spectrum_strategy": spectrum_strategy,
        "path_type": path_type,
        "parallelpath_strategy": parallelpath_strategy
    }
    print(
        f"--- Sending REQUEST: {src} -> {dst} at {bitrate} Gbps (path_strategy: {path_strategy}, spectrum_strategy: {spectrum_strategy}) ---")
    try:
        resp = requests.post(API_URL, json=payload)
        print(f"Status Code: {resp.status_code}")
        print(json.dumps(resp.json(), indent=4))
    except Exception as e:
        print(f"Error connecting to server: {e}")


def test_teardown(lightpath_id):
    payload = {
        "lightpath_id": lightpath_id
    }
    print(f"--- Sending TEARDOWN for Lightpath ID: {lightpath_id} ---")
    try:
        resp = requests.post(TEARDOWN_URL, json=payload)
        print(f"Status Code: {resp.status_code}")
        print(json.dumps(resp.json(), indent=4))
    except Exception as e:
        print(f"Error connecting to server: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Manual RSA API Tester")
    parser.add_argument('action', choices=[
                        'request', 'teardown'], help="Which API endpoint to test")

    # Request Arguments
    parser.add_argument('--src', type=str, default='RDMca1',
                        help="Source device name (default: RDMca1)")
    parser.add_argument('--dst', type=str, default='RDMny',
                        help="Destination device name (default: RDMny)")
    parser.add_argument('--bitrate', type=int, default=100,
                        help="Bitrate in Gbps (default: 100)")
    parser.add_argument('--path_strategy', type=str, default='first-fit',
                        choices=['first-fit', 'last-fit',
                                 'highest-slot', 'random'],
                        help="Path selection strategy (default: first-fit)")
    parser.add_argument('--spectrum_strategy', type=str, default='first-fit',
                        choices=['first-fit', 'last-fit', 'random'],
                        help="Spectrum selection strategy (default: first-fit)")
    parser.add_argument('--path_type', type=str, default='dijkstra',
                        choices=['dijkstra', 'additional', 'both'],
                        help="Path generation type (default: dijkstra)")
    parser.add_argument('--parallelpath_strategy', type=str, default='none',
                        choices=['first-fit', 'last-fit',
                                 'random', 'highest-slot', 'none'],
                        help="Parallel path expansion strategy (default: none)")

    # Teardown Arguments
    parser.add_argument('--id', type=str, help="Lightpath ID for teardown")

    args = parser.parse_args()

    if args.action == 'request':
        test_request(args.src, args.dst, args.bitrate, args.path_strategy,
                     args.spectrum_strategy, args.path_type, args.parallelpath_strategy)
    elif args.action == 'teardown':
        if not args.id:
            print(
                "Error: You must provide a Lightpath ID using '--id' for the teardown endpoint.")
            sys.exit(1)
        test_teardown(args.id)
