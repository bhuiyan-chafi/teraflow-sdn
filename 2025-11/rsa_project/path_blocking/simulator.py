"""
Confidence Interval Based Simulation for Optical Network Blocking Probability

Stopping Criteria:
1. CI <= 5% of blocking probability at 95% confidence level, OR
2. Maximum 10^4 independent trials reached

Results are output only when one of these conditions is met.

RUN: nohup python3 -u -W ignore simulator.py > results/NSF_1_1.txt 2>&1 &
"""

import requests
import random
import heapq
import math
import json
import time
from collections import Counter
from sim_config import (
    NODES, BIT_RATE, ERLANGS, HOLDING_TIME, Z_VALUE,
    TRANSIENT_UNIT, MAX_TRIALS, MIN_TRIALS, CI_THRESHOLD
)
import warnings

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
        return self.v_time < other.v_time


def calculate_ci(blocked, total, z_value):
    """
    Calculate the confidence interval for blocking probability.
    Returns (probability, absolute_ci, relative_ci)
    """
    if total == 0:
        return 0.0, 0.0, float('inf')

    prob = blocked / float(total)

    if prob == 0 or prob == 1:
        # Edge case: CI calculation not meaningful
        return prob, 0.0, float('inf')

    # Standard error and CI
    absolute_ci = z_value * math.sqrt((prob * (1 - prob)) / total)

    # Relative CI = absolute_ci / prob (as a fraction of the estimate)
    relative_ci = absolute_ci / prob if prob > 0 else float('inf')

    return prob, absolute_ci, relative_ci


def check_stopping_condition(blocked, total, z_value, ci_threshold, max_trials, min_trials):
    """
    Check if stopping conditions are met.
    Returns (should_stop, reason, stats)

    Conditions:
    1. Relative CI <= ci_threshold (5%) at 95% confidence level
    2. Maximum trials reached (10^4)
    """
    prob, absolute_ci, relative_ci = calculate_ci(blocked, total, z_value)

    stats = {
        "trials": total,
        "blocked": blocked,
        "probability": prob,
        "absolute_ci": absolute_ci,
        "relative_ci": relative_ci
    }

    # Condition 2: Maximum trials reached
    if total >= max_trials:
        return True, "MAX_TRIALS_REACHED", stats

    # Condition 1: CI threshold met (only check after minimum trials)
    if total >= min_trials and relative_ci <= ci_threshold:
        return True, "CI_THRESHOLD_MET", stats

    return False, None, stats


def run_simulation():
    results = []

    for b_rate in sorted(list(BIT_RATE)):
        for erlang in sorted(list(ERLANGS)):
            print(f"============================================================")
            print(
                f"STARTING CI-BASED SIM: BITRATE={b_rate}G | ERLANG={erlang}")
            print(
                f"Stopping: CI <= {CI_THRESHOLD*100}% of P_b OR max {MAX_TRIALS} trials")
            print(f"============================================================")

            arrival_rate = erlang / HOLDING_TIME
            event_queue = []

            first_arrival_delay = random.expovariate(arrival_rate)
            heapq.heappush(event_queue, Event(first_arrival_delay, "ARRIVAL"))

            virtual_time = 0.0
            transient_limit = TRANSIENT_UNIT * HOLDING_TIME

            transient_requests = 0
            transient_blocked = 0
            counted_requests = 0
            blocked_requests = 0
            active_connections = 0
            entered_steady_state = False

            blocking_reasons = Counter()

            stop_reason = None
            last_progress_report = 0
            progress_interval = 1000  # Report progress every 500 trials

            # Main Discrete Event Loop - runs until stopping condition met
            while True:
                if not event_queue:
                    break

                current_event = heapq.heappop(event_queue)
                virtual_time = current_event.v_time

                if current_event.event_type == "ARRIVAL":
                    # Queue the next arrival
                    next_arrival_time = virtual_time + \
                        random.expovariate(arrival_rate)
                    heapq.heappush(event_queue, Event(
                        next_arrival_time, "ARRIVAL"))

                    # Build random payload
                    src, dst = random.sample(NODES, 2)
                    bitrate = b_rate

                    payload = {
                        "src_device": src,
                        "dst_device": dst,
                        "bitrate": bitrate
                    }

                    # Execute API with retry logic
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
                            print(
                                f"\n--- TRANSIENT PHASE ENDED at {virtual_time:.2f}s ---")
                            print(
                                f"    Transient: {transient_requests} requests, {transient_blocked} blocked")
                            entered_steady_state = True

                        if status == 'success':
                            active_connections += 1
                            lp_id = resp.get('lightpath_id')
                            teardown_time = virtual_time + HOLDING_TIME
                            heapq.heappush(event_queue, Event(
                                teardown_time, "TEARDOWN", {"id": lp_id}))
                        else:
                            reason = resp.get('reason', 'Unknown')

                        # Count in appropriate phase
                        if entered_steady_state:
                            counted_requests += 1
                            if status != 'success':
                                blocked_requests += 1
                                reason = resp.get('reason', 'Unknown')
                                blocking_reasons[reason] += 1

                            # Progress reporting
                            if counted_requests - last_progress_report >= progress_interval:
                                last_progress_report = counted_requests
                                prob, abs_ci, rel_ci = calculate_ci(
                                    blocked_requests, counted_requests, Z_VALUE)
                                print(f"    Progress: {counted_requests} trials | "
                                      f"P_b={prob:.6f} | CI={abs_ci:.6f} | "
                                      f"Rel.CI={rel_ci*100:.2f}%")

                            # Check stopping condition
                            should_stop, reason, stats = check_stopping_condition(
                                blocked_requests, counted_requests, Z_VALUE,
                                CI_THRESHOLD, MAX_TRIALS, MIN_TRIALS
                            )

                            if should_stop:
                                stop_reason = reason
                                break
                        else:
                            transient_requests += 1
                            if status != 'success':
                                transient_blocked += 1

                elif current_event.event_type == "TEARDOWN":
                    lp_id = current_event.data['id']
                    max_retries = 3
                    for attempt in range(max_retries):
                        try:
                            td_resp = requests.post(
                                TEARDOWN_URL, json={"lightpath_id": lp_id}, timeout=30).json()
                            if td_resp.get('status') == 'success':
                                active_connections -= 1
                            break
                        except Exception as e:
                            if attempt < max_retries - 1:
                                time.sleep(0.5 * (attempt + 1))

            # Calculate final results
            total = counted_requests
            prob, absolute_ci, relative_ci = calculate_ci(
                blocked_requests, total, Z_VALUE)

            stat_dict = {
                "bitrate": b_rate,
                "load": erlang,
                "stop_reason": stop_reason,
                "total_trials": total,
                "transient_contention_rate": round(
                    (transient_blocked/transient_requests)*100, 8) if transient_requests > 0 else 0,
                "successful_requests": total - blocked_requests,
                "blocked_requests": blocked_requests,
                "blocking_probability": round(prob, 8),
                "absolute_confidence_interval": round(absolute_ci, 8),
                "relative_confidence_interval_pct": round(relative_ci * 100, 4),
                "ci_threshold_pct": CI_THRESHOLD * 100,
                "confidence_level_pct": 95,
                "max_trials_limit": MAX_TRIALS,
                "blocking_reasons": dict(blocking_reasons)
            }
            results.append(stat_dict)

            # Output result only when stopping condition is met
            print(f"\n{'='*60}")
            print(f"SIMULATION COMPLETED - {stop_reason}")
            print(f"{'='*60}")
            print(json.dumps(stat_dict, indent=4), flush=True)

            # Cleanup remaining lightpaths
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

    return results


if __name__ == "__main__":
    run_simulation()
