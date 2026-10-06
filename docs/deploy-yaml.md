# The deploy file

`deploy.yaml` is the only artifact you keep. It holds desired state plus the two fields `apply` writes back (`gateway.url`, `gateway.admin_token`). Any value can be a literal or `${ENV_VAR}` (with `:-default` fallbacks); the CLI resolves env vars locally before pushing.

Unknown fields are a hard error, so typos fail loudly.

## Full schema

```yaml
version: 1                      # must be 1
name: acme-ai                   # [a-z0-9-]{3,32}, used in resource names and tags

provider:
  type: aws                     # aws | gcp | azure | runpod | lambda | hyperbolic | ssh | fake
  region: us-east-1             # not used for ssh
  capacity: spot-fallback       # spot | on-demand | spot-fallback | serverless (runpod only)
  subnet: null                  # optional aws/gcp/azure: use instead of the default network
  hosts:                        # ssh only: your machines
    - {addr: 10.0.0.5, user: ubuntu, gpus: 2, cost_hr: 0.30}

budget:
  monthly_usd: 500              # hard cap; null/absent = unlimited (ssh defaults to unlimited)

alerts:
  webhook: https://ntfy.sh/...  # optional; receives generic JSON posts at 80/90/95%

gateway:
  domain: ai.acme.com           # optional; default <ip-dashed>.sslip.io
  host: null                    # optional ssh://user@host; required for lambda and hyperbolic
  url: https://...              # written by apply
  admin_token: gr_admin_...     # written by apply

models:                         # ids must exist in the catalog
  - id: llama-3.1-8b-instruct
    variant: awq                # optional; one of the catalog's tested variants
    replicas: {min: 0, max: 4}  # defaults 0 / 1
    idle_timeout: 15m           # scale to zero after this idle; default 15m

keys:
  - name: alice
    key: ${ALICE_KEY}           # the value users present as Bearer tokens
    models: ["*"]               # which catalog ids this key may use
    limits:
      rpm: 60                   # token bucket
      tokens_per_day: 200000    # from engine usage (streaming included)
      stt_mb_per_day: 200       # request body size
      tts_chars_per_day: 100000 # input length

secrets:
  hf_token: ${HF_TOKEN}         # needed for gated models; passed to nodes
```

## Semantics

- **capacity** — `on-demand` is what people usually call "dedicated". `spot-fallback` tries spot first and falls back to on-demand at launch time and on interruption. `serverless` (RunPod only) delegates scaling to the provider.
- **ssh pools are fixed** — `max` is bounded by the GPUs that physically exist. Spend is `cost_hr` x uptime; the budget is ignored.
- **api model names** — the `model` field in requests is the catalog `id`, e.g. `"llama-3.1-8b-instruct"`.
- **secrets** — the file is plaintext by design and belongs to you; use env references for hygiene. The gateway stores the resolved config in its data dir.

## Validation

`spec.Validate` runs in the CLI before any push, and again in the gateway on receipt; a rejected push keeps the previous config running.
