import requests
import random
import heapq
import math
import json
import time
from collections import Counter
from sim_config import NSF_NODES, BIT_RATE, ERLANGS, N_REQ, HOLDING_TIME, Z_VALUE, TRANSIENT_UNIT
import warnings
# Setup warning suppression before importing requests/urllib3
warnings.filterwarnings(
    "ignore", message=".*urllib3 v2 only supports OpenSSL.*")


API_URL = "http://127.0.0.1:5001/api/lightpath/request"
TEARDOWN_URL = "http://127.0.0.1:5001/api/lightpath/teardown"


class Event:
    def __init__(self, v_time, event_type, data=None):
        self.v_time = v_time
        self.event_type = event_type  # "ARRIVAL" or "TEARDOWN"
        self.data = data or {}

    def __lt__(self, other):
        # Priority Queue uses this to sort virtual timestamps chronologically
        return self.v_time < other.v_time


def run_simulation():
    results = []

    # Loop over BIT_RATE > N_REQ > ERLANGS
    for b_rate in sorted(list(BIT_RATE)):
        for n_req in sorted(list(N_REQ)):
            for erlang in sorted(list(ERLANGS)):
                # print(f"============================================================")
                # print(
                #     f"STARTING SIM: BITRATE={b_rate}G | N_REQ={n_req} | ERLANG={erlang}")
                # print(f"============================================================")

                arrival_rate = erlang / HOLDING_TIME
                event_queue = []

                # 1. Schedule the very first mathematical Arrival
                first_arrival_delay = random.expovariate(arrival_rate)
                heapq.heappush(event_queue, Event(
                    first_arrival_delay, "ARRIVAL"))

                virtual_time = 0.0
                # Set transient limit to TRANSIENT_UNIT holding times for warm-up phase
                transient_limit = TRANSIENT_UNIT * HOLDING_TIME

                transient_requests = 0
                transient_blocked = 0
                counted_requests = 0
                blocked_requests = 0
                active_connections = 0
                entered_steady_state = False

                # Track blocking reasons during steady state only
                blocking_reasons = Counter()

                # print(
                #     f"\n--- [TRANSIENT PHASE INITIATED] (Warm-up until {transient_limit}s) ---")

                # 2. Main Discrete Event Loop
                while counted_requests < n_req:
                    if not event_queue:
                        break

                    current_event = heapq.heappop(event_queue)

                    # FAST FORWARD VIRTUAL TIME precisely to the millisecond of the next event
                    virtual_time = current_event.v_time

                    if current_event.event_type == "ARRIVAL":
                        # A. Queue the next mathematical arrival
                        next_arrival_time = virtual_time + \
                            random.expovariate(arrival_rate)
                        heapq.heappush(event_queue, Event(
                            next_arrival_time, "ARRIVAL"))

                        # B. Build random payload
                        src, dst = random.sample(NSF_NODES, 2)

                        bitrate = b_rate

                        payload = {
                            "src_device": src,
                            "dst_device": dst,
                            "bitrate": bitrate
                        }

                        # C. Execute the backend API with retry logic
                        max_retries = 3
                        resp = None
                        for attempt in range(max_retries):
                            try:
                                resp = requests.post(
                                    API_URL, json=payload, timeout=30).json()
                                status = resp.get('status')
                                break
                            except Exception as e:
                                if attempt < max_retries - 1:
                                    time.sleep(0.5 * (attempt + 1))
                                else:
                                    print(
                                        f"API Request Error after {max_retries} attempts: {e}")
                                    status = 'error'
                                    resp = {'status': 'error',
                                            'reason': 'API_CONNECTION_FAILED'}

                        if resp:
                            status = resp.get('status')

                            if virtual_time >= transient_limit and not entered_steady_state:
                                # print(
                                #     f"\n============================================================")
                                # print(
                                #     f" END OF TRANSIENT PHASE. ENTERING STEADY STATE ")
                                # print(
                                #     f" Transient Requests: {transient_requests} | Success: {transient_requests - transient_blocked} | Blocked: {transient_blocked}")
                                # print(
                                #     f" Active Connections Right Now: {active_connections}")
                                # if transient_requests > 0:
                                #     print(
                                #         f" Transient Contention Rate: {(transient_blocked/transient_requests)*100:.2f}%")
                                # print(
                                #     f"============================================================\n")
                                entered_steady_state = True

                            phase_label = "STEADY" if entered_steady_state else "TRANSIENT"

                            # Log every request for Saturation Test visibility
                            if status == 'success':
                                active_connections += 1
                                lp_id = resp.get('lightpath_id')
                                teardown_time = virtual_time + HOLDING_TIME
                                heapq.heappush(event_queue, Event(
                                    teardown_time, "TEARDOWN", {"id": lp_id}))
                                # print(
                                #     f"[{virtual_time:.2f}s] [{phase_label}] SUCCESS: {src}->{dst} (ID: {lp_id[:8]}...)")
                            else:
                                reason = resp.get('reason', 'Unknown')
                                # print(
                                #     f"[{virtual_time:.2f}s] [{phase_label}] BLOCKED: {src}->{dst} ({reason})")

                            # E. Check if we passed the Transient State
                            if entered_steady_state:
                                counted_requests += 1
                                if status != 'success':
                                    blocked_requests += 1
                                    # Track blocking reason in steady state
                                    reason = resp.get('reason', 'Unknown')
                                    blocking_reasons[reason] += 1

                                # Logging progress every request for clarity in small tests
                                # if counted_requests <= 150:  # Only for small N_REQ
                                #     print(
                                #         f"   -> Progress: {counted_requests}/{N_REQ} (Success: {counted_requests - blocked_requests}, Blocked: {blocked_requests})")
                            else:
                                transient_requests += 1
                                if status != 'success':
                                    transient_blocked += 1

                    elif current_event.event_type == "TEARDOWN":
                        # F. A lightpath holding time expired! Fire the API to extract its endpoints and run bitwise OR to free it.
                        lp_id = current_event.data['id']
                        max_retries = 3
                        for attempt in range(max_retries):
                            try:
                                td_resp = requests.post(
                                    TEARDOWN_URL, json={"lightpath_id": lp_id}, timeout=30).json()
                                if td_resp.get('status') == 'success':
                                    active_connections -= 1
                                    # print(
                                    #     f"[{virtual_time:.3f}s] TEARDOWN: Lightpath {lp_id} successfully released.")
                                else:
                                    print(
                                        f"[{virtual_time:.3f}s] TEARDOWN FAILED: Lightpath {lp_id}.")
                                break
                            except Exception as e:
                                if attempt < max_retries - 1:
                                    time.sleep(0.5 * (attempt + 1))
                                else:
                                    pass  # Silently fail after retries

                # 3. Calculate Results for this Erlang
                total = counted_requests
                prob = blocked_requests / float(total) if total > 0 else 0
                ci = Z_VALUE * math.sqrt((prob * (1 - prob)) /
                                         total) if total > 0 else 0

                stat_dict = {
                    "bitrate": b_rate,
                    "n_req": n_req,
                    "load": erlang,
                    "total_requests": total,
                    "transient_contention_rate": round((
                        transient_blocked/transient_requests)*100, 8),
                    "successful_requests": total - blocked_requests,
                    "blocked_requests": blocked_requests,
                    "blocking_probability": round(prob, 6),
                    "confidence_interval": round(ci, 6),
                    "blocking_reasons": dict(blocking_reasons)
                }
                results.append(stat_dict)

                # Print this iteration's result immediately
                print(json.dumps(stat_dict, indent=4), flush=True)

                # 4. Wipe Network Clean for the Next Erlang iteration!
                # print(
                #     "Cleaning up remaining active lightpaths from topology before next Erlang starts...\n")
                while event_queue:
                    ev = heapq.heappop(event_queue)
                    if ev.event_type == "TEARDOWN":
                        for attempt in range(3):
                            try:
                                requests.post(TEARDOWN_URL, json={
                                              "lightpath_id": ev.data['id']}, timeout=30)
                                break
                            except:
                                if attempt < 2:
                                    time.sleep(0.5 * (attempt + 1))


if __name__ == "__main__":
    run_simulation()
