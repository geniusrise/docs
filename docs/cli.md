# CLI and GUI

## CLI

```
geniusrise init                     wizard -> deploy.yaml
geniusrise catalog [query]          list curated models
geniusrise plan [--compare]         placement + $/month; compare works with no cloud account
geniusrise apply [--recreate-gateway]
geniusrise status                   pools, nodes, spend vs budget
geniusrise logs <node>              engine logs
geniusrise destroy [--yes]
geniusrise key new                  generate sk-gr-... to paste into keys:
geniusrise doctor [ssh://host]      credentials, quotas, host readiness
geniusrise gui                      local web ui
geniusrise gateway | node | host join   daemon modes
```

All file commands accept `-f path` (default `./deploy.yaml`) and `--catalog path|url`.

## Upgrades

- `apply` notices a gateway version older than the CLI and triggers a rolling upgrade (gateway first, then node replacement one at a time — new node starts before the old drains).
- Image digests are pinned per release; changing them replaces nodes the same way.

## GUI

`geniusrise gui -f deploy.yaml` starts a local web UI:

- binds to `127.0.0.1` on a random port
- the launch URL carries a random session token; a Host header check blocks DNS rebinding
- reads and writes the yaml file on disk — the file stays the source of truth
- screens: deployment, models (catalog browser), provider & budget (with cross-provider cost compare), keys, plan & apply (streamed progress), status (live), yaml editor (two-way)

No javascript framework, no npm: templates are embedded in the binary.
