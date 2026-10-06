# Layout and testing

## Layout

```
cmd/geniusrise/          entrypoint, mode dispatch
internal/spec            deploy.yaml types, strict parse, env resolution, writeback
internal/catalog         recipe types, embedded loader, engine commands
internal/pricing         snapshot types, cache, embedded fallback
internal/planner         pure: (spec, catalog, prices) -> plan
internal/gateway         api, auth+limits, router, autoscaler, budget, reconciler, state
internal/tunnel          CA, join tokens, mTLS ALPN routing, yamux tunnel, RPC
internal/node            engine supervisor, canary, spot watchers, admin endpoint
internal/hostagent       ssh host mode (docker per gpu)
internal/provider        interface; fake, ssh, aws (gcp/azure/runpod in P2/P3)
internal/gui             templates + static, localhost session guard
internal/cli             commands
catalog/*.yaml           recipes
images/<engine>/         Dockerfiles
tools/pricegen           daily price snapshot generator
```

## Testing strategy

- **unit** — spec validation golden tests, planner table tests against a fixed snapshot, autoscaler/budget on a simulated clock, limits accounting
- **in-process integration** (every PR) — gateway + fake provider + fake engine over a real tunnel: scale-from-zero with streaming, canary-detected replacement, spot interruption fallback, orphan cleanup, budget thresholds, invalid config rejection, state restore
- **provider contract suite** — one suite; runs against the fake in CI, against real clouds via `make e2e PROVIDER=<p>` (opt-in, budget-capped test account, cpu variants)
- **catalog** — CI validates schema; `tested:` is mandatory

```
make test     # everything above except real clouds
make e2e PROVIDER=aws
```

## Conventions

- no comments in code unless a comment is the point
- gofmt-clean, `go vet` clean, tests green — CI enforces all three
- one feature or logical block per commit
