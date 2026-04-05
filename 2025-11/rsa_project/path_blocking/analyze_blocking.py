#!/usr/bin/env python3
"""
Analyze blocking reasons from API responses.
This script wraps the simulator to track which blocking reasons occur most frequently.
"""

import json
from collections import Counter

# Track blocking reasons
blocking_reasons = Counter()
total_requests = 0
successful_requests = 0


def track_response(response_json):
    """Track the response from the API"""
    global total_requests, successful_requests, blocking_reasons

    total_requests += 1
    status = response_json.get('status')

    if status == 'success':
        successful_requests += 1
    else:
        reason = response_json.get('reason', 'Unknown')
        blocking_reasons[reason] += 1


def print_summary():
    """Print summary of blocking reasons"""
    print("\n" + "="*60)
    print("BLOCKING REASON ANALYSIS")
    print("="*60)
    print(f"Total Requests: {total_requests}")
    print(
        f"Successful: {successful_requests} ({100*successful_requests/total_requests:.1f}%)")
    print(
        f"Blocked: {sum(blocking_reasons.values())} ({100*sum(blocking_reasons.values())/total_requests:.1f}%)")
    print("\nBlocking Breakdown:")
    print("-"*60)

    for reason, count in blocking_reasons.most_common():
        pct = 100 * count / total_requests
        print(f"  {reason:45s}: {count:5d} ({pct:5.2f}%)")

    print("="*60)
    print("\nInterpretation:")
    print("-"*60)
    if "No valid route found" in blocking_reasons:
        pct = 100 * \
            blocking_reasons["No valid route found"] / \
            sum(blocking_reasons.values())
        print(f"• OCH Port Exhaustion: {pct:.1f}% of all blocks")
        print("  → Transponders ran out of available OCH links")
        print("  → This is the PRIMARY bottleneck!")

    if "No spectrum available" in blocking_reasons:
        pct = 100 * \
            blocking_reasons["No spectrum available"] / \
            sum(blocking_reasons.values())
        print(f"• Spectrum Fragmentation: {pct:.1f}% of all blocks")
        print("  → No contiguous slots available on path")

    if "Persistent resource contention" in blocking_reasons:
        pct = 100 * \
            blocking_reasons["Persistent resource contention"] / \
            sum(blocking_reasons.values())
        print(f"• Race Conditions: {pct:.1f}% of all blocks")
        print("  → Multiple requests competing for same resources")

    print("="*60)


if __name__ == "__main__":
    print("This module is meant to be imported by the simulator.")
    print("Add the following to simulator.py to track blocking:")
    print("""
    from analyze_blocking import track_response, print_summary
    
    # After each API call:
    track_response(resp)
    
    # At the end:
    print_summary()
    """)
