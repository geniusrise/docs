# Budgets and limits

## The hard monthly cap

Spend is estimated continuously: every node carries a `geniusrise:price_hr` tag stamped at launch, and the gateway sums uptime x price plus the prorated gateway cost. Calendar months, UTC.

| spend / budget | action |
|---|---|
| >= 80% | webhook alert |
| >= 90% | **freeze**: no new scale-ups; scale-down continues |
| >= 95% | **cap**: every model scales to zero and an alert fires. lasts until the month rolls over or you raise `budget.monthly_usd` |

The gateway VM stays up (it costs a few dollars a month).

These are compute estimates, not invoices: egress and minor charges are not counted. Enforcing at 95% is the safety margin — real invoices will differ slightly.

## Autoscaling

Per model, every 15 seconds:

```
desired = clamp(ceil(avg_inflight_1m / (concurrency * 0.7)), min, max)
```

- launching nodes count as capacity (no thundering herds)
- scale-up is immediate; scale-down waits 5 minutes of low load
- `min: 0` enables scale-to-zero after `idle_timeout`
- cold requests trigger a scale-up and are held up to 20s, then answered with `503` + `Retry-After`

## Spot interruptions

Node agents poll the provider's interruption signal (AWS 2-minute notice, GCP preemption metadata, Azure scheduled events). On notice the node drains in-flight requests and the gateway launches a replacement — next offering in the ranked list, which with `spot-fallback` can be on-demand.

## Per-key limits

- `rpm` — token bucket per key
- `tokens_per_day` — from engine usage; streaming is counted by injecting `stream_options.include_usage`
- `stt_mb_per_day` / `tts_chars_per_day` — measured on the request itself (decoding audio minutes would require a decoder on the hot path)
- keys are hashed in gateway memory; prompts, completions and audio are never logged
