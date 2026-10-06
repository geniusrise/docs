# Architecture

```
 laptop / admin box                     customer's provider (one per deployment)
┌──────────────────────┐   HTTPS +    ┌──────────────────────────────────┐
│ geniusrise cli / gui │──admin token─▶ geniusrise gateway (tiny CPU VM) │
│  reads deploy.yaml   │              │  OpenAI API · keys · autoscaler  │
│  uses local creds    │              │  budget · reconciler · adapter   │
└──────────────────────┘              └────────┬─────────────────────────┘
        ▲                                      ▲ reverse tunnel (node dials out,
 end users (api keys) ─── HTTPS ───────────────┤  mTLS + yamux on :443)
                                     ┌─────────┴─────────┐ ┌───────────────┐
                                     │ gpu/cpu node      │ │ node ...      │
                                     │ geniusrise node   │ │               │
                                     │  └ vllm/llamacpp/ │ │               │
                                     │    speaches       │ │               │
                                     └───────────────────┘ └───────────────┘
```

## One binary, four modes

| mode | runs on | does |
|---|---|---|
| cli / gui | admin machine | plan, bootstrap, push config, status, destroy |
| gateway | tiny CPU VM in the customer's provider | public API, auth, limits, routing, autoscaling, budget, reconciliation |
| node | each replica (image entrypoint) | supervises the engine, joins the tunnel, canary checks, spot watcher |
| host join | each ssh host | starts/stops engine containers on local GPUs |

## Control flow

1. first `apply` — the CLI plans, bootstraps the gateway via the provider adapter using local credentials, pushes the resolved config, writes `gateway.url` + `admin_token` into the yaml
2. later `apply` — config push only; the gateway diffs and converges
3. the gateway loop, every 15s — autoscaler computes desired replicas per model, the reconciler launches/terminates through the adapter, and orphans (tagged instances it does not know) are terminated

## The reverse tunnel

Nodes listen on nothing. Each node dials out to the gateway on 443, negotiates TLS with ALPN `gr-tunnel`, authenticates with a client certificate signed by the deployment CA (issued over a single-use 30-minute join token), then multiplexes with yamux. The gateway opens streams back through that session to reach the engine on `127.0.0.1`. This gives identical security posture on every provider and makes NAT'd machines first-class.

## Self-healing

| layer | detects | does |
|---|---|---|
| node → engine | exit, failed /health, canary inference timeout | restart with backoff; after 3 failures/10min reports unhealthy |
| gateway → node | missed heartbeats, unhealthy, error rate | stop routing, terminate, replace |
| reconciler → provider | tagged instances not in the registry | terminate (stops zombie spend) |
| systemd/provider → gateway | crash or VM failure | Restart=always + provider auto-recovery; `apply --recreate-gateway` rebuilds from yaml + tags + data disk |

## Pricing pipeline

A daily CI job publishes `prices.json` (AWS pricing API + spot history, GCP billing catalog, Azure retail, RunPod/Lambda/Hyperbolic APIs) as a release asset; binaries embed a fallback snapshot and cache the latest for 24h. The gateway refines live at launch (actual AZ spot price) and stamps the price on the instance tag.
