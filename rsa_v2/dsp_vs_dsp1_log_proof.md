# Proof From Logs: Why DSP+1 Performs Worse Than DSP

## The Smoking Gun: Random Path Selection Picks Longer Paths 47.2% of the Time

From the logs, when DSP+1 discovers candidates for a request, the **shortest available candidate** has the same hop distribution as DSP:

| Shortest candidate available | DSP (chosen) | DSP+1 (available) |
|---|---|---|
| 1-hop | 24.3% | 23.7% |
| 2-hop | 38.6% | 38.5% |
| 3-hop | 31.5% | 32.1% |
| 4-hop | 5.6% | 5.7% |

This confirms `all_simple_paths(cutoff=dsp+1)` **includes** the shortest paths. The shortest candidate is virtually identical to what DSP would pick.

But look at what DSP+1 **actually chooses** with random selection:

| Hops | DSP chosen | DSP+1 chosen | DSP+1 candidate pool |
|---|---|---|---|
| 1-hop | **24.3%** | 19.2% | 6.5% |
| 2-hop | **38.6%** | 25.8% | 15.4% |
| 3-hop | **31.5%** | 27.8% | 27.5% |
| 4-hop | 5.6% | **23.3%** | 36.5% |
| 5-hop | — | **3.9%** | 14.1% |

> [!CAUTION]
> **47.2% of the time**, DSP+1 randomly chose a path that was **LONGER** than the shortest available candidate for the same source-destination pair.
>
> In those 3,936 out of 8,341 requests, DSP+1 picked a 4-hop path when a 2 or 3-hop path was available, or a 3-hop when a 1-hop was available.

---

## Why This Happens: Random Selection Bias

The candidate pool is **dominated by longer paths**. With `cutoff=dsp+1`:

```
For a 2-hop DSP pair, candidates might be:
  1× 2-hop path  (the shortest)
  3× 3-hop paths (the dsp+1 alternatives)

Random selection → 75% chance of picking a 3-hop path
```

The **distribution of the candidate pool** shows this clearly:
- 1-hop candidates: only 6.5%
- 4-hop candidates: **36.5%** ← the majority of the pool

Random selection is essentially **weighted toward longer paths** because there are more of them in the search space. This is a mathematical property of graph enumeration: there are always more long simple paths than short ones.

---

## The Quantified Damage

| Metric | DSP | DSP+1 | Impact |
|---|---|---|---|
| Avg hops per chosen path | **2.185** | **2.670** | +22.2% longer |
| Total link-allocations (~8.4K requests) | 18,676 | 22,268 | +19.2% more |
| Link-allocations per request | 2.185 | 2.670 | **+22.2% more spectrum per connection** |
| Unique link segments used | 22 | 22 | **identical** |

> [!IMPORTANT]
> **DSP+1 uses the exact same 22 link segments as DSP. Zero new links. Zero new diversity.**
>
> The extra paths are just longer routes through the **same physical links**. They add no topological diversity — they only add extra hops through links that are already congested.

---

## The Mechanism: Each Request Wastes 22% More Spectrum

In RSA, every hop in a chosen path allocates spectrum on that link:
- DSP: 2.185 links allocated per request on average
- DSP+1: 2.670 links allocated per request on average

At steady state with Erlang load λ:
- DSP holds `λ × 2.185` link-spectrum-units simultaneously
- DSP+1 holds `λ × 2.670` link-spectrum-units simultaneously

That's **22.2% more spectrum locked** at any given moment. On the same 22 links with the same total capacity, this directly translates to higher contention and higher blocking.

---

## The Full Causal Chain

```
More candidate paths at dsp+1
    ↓
Candidate pool is dominated by longer paths (4-5 hops = 50.6% of pool)
    ↓
Random selection picks longer path 47.2% of the time
    ↓
Each connection uses 22.2% more links on average
    ↓
Same 22 links (zero new diversity), but 22.2% more spectrum consumed
    ↓
Network saturates faster → higher P_b
```

> [!TIP]
> **This also explains why `highest-slot` (spectrum check) doesn't fully save DSP+1**: even when you pick the "best" path from the candidate pool, if the best path is 4 hops, it still consumes more spectrum than a 3-hop DSP path. The spectrum-check strategy mitigates the random selection problem, but it cannot overcome the fundamental physics: more hops = more spectrum per connection through the same links.
