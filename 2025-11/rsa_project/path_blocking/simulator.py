import requests
import json
import time

API_URL = "http://127.0.0.1:5001/api/lightpath/request"

def run_simulation():
    # 1. Define Request Parameters
    payload = {
        "src_device": "TPmissouri",
        "dst_device": "TPtexas",
        "bitrate": 400
    }

    print(f"--- Triggering Request: {payload['src_device']} -> {payload['dst_device']} ({payload['bitrate']} Gbps) ---")
    
    # 2. Make the POST request
    try:
        response = requests.post(API_URL, json=payload)
        
        # 3. Parse and Display Output
        print(f"Response Code: {response.status_code}\n")
        
        try:
            data = response.json()
            print(json.dumps(data, indent=4))
            
            if data.get('status') == 'success':
                comp_time = data.get("computation_time_s", 0)
                lp_id = data.get("lightpath_id")
                print(f"\n✅ SUCCESS: Path computed & slots acquired in {comp_time:.4f}s")
                print(f"   Lightpath ID: {lp_id}")
                
                print("\n--- Triggering Instant Teardown Request ---")
                teardown_payload = {"lightpath_id": lp_id}
                td_resp = requests.post(API_URL.replace('request', 'teardown'), json=teardown_payload)
                
                try:
                    td_data = td_resp.json()
                    print(json.dumps(td_data, indent=4))
                    if td_data.get('status') == 'success':
                        td_time = td_data.get("teardown_time_s", 0)
                        print(f"\n✅ SUCCESS: Path torn down and slots released in {td_time:.4f}s")
                    else:
                        print(f"\n❌ TEARDOWN FAILED: {td_data.get('reason')}")
                except ValueError:
                    print("Teardown Raw Response:", td_resp.text)
                    
            elif data.get('status') == 'path-blocked':
                print(f"\n❌ BLOCKED: {data.get('reason')}")
            else:
                print(f"\n⚠️ ERROR: {data.get('reason')}")
                
        except ValueError:
            print("Raw Response:", response.text)
            
    except requests.exceptions.ConnectionError:
        print(f"Connection Error: Is the API running at {API_URL}?")

if __name__ == "__main__":
    run_simulation()
