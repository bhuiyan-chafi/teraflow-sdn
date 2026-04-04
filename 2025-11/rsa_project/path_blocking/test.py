# python path_blocking/test.py request --src TPmissouri --dst TPtexas --bitrate 400
# python path_blocking/test.py teardown --id YOUR_LIGHTPATH_ID_HERE

import requests
import json
import argparse
import sys

API_URL = "http://127.0.0.1:5001/api/lightpath/request"
TEARDOWN_URL = "http://127.0.0.1:5001/api/lightpath/teardown"

def test_request(src, dst, bitrate):
    payload = {
        "src_device": src,
        "dst_device": dst,
        "bitrate": bitrate
    }
    print(f"--- Sending REQUEST: {src} -> {dst} at {bitrate} Gbps ---")
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
    parser.add_argument('action', choices=['request', 'teardown'], help="Which API endpoint to test")
    
    # Request Arguments
    parser.add_argument('--src', type=str, default='TPcalifornia', help="Source device name (default: TPcalifornia)")
    parser.add_argument('--dst', type=str, default='TPnewyork', help="Destination device name (default: TPnewyork)")
    parser.add_argument('--bitrate', type=int, default=100, help="Bitrate in Gbps (default: 100)")
    
    # Teardown Arguments
    parser.add_argument('--id', type=str, help="Lightpath ID for teardown")

    args = parser.parse_args()

    if args.action == 'request':
        test_request(args.src, args.dst, args.bitrate)
    elif args.action == 'teardown':
        if not args.id:
            print("⚠️ Error: You must provide a Lightpath ID using '--id' for the teardown endpoint.")
            sys.exit(1)
        test_teardown(args.id)
