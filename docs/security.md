# Security

## Baseline (identical on every provider)

**GPU nodes**

- no inbound firewall rules at all, no SSH keypair where the provider allows it
- no cloud IAM role — nodes need no cloud permissions
- IMDSv2 required on AWS
- unprivileged containers, read-only root filesystem except caches
- outbound only: Hugging Face, the registry, the gateway

**Gateway**

- inbound 443 only; TLS via ACME (TLS-ALPN-01, no port 80); no SSH
- its cloud role is scoped by deployment tag/name to launch, terminate and describe instances plus read pricing

**Images** — pinned by digest per release, signed with cosign in CI (on-node verification is planned).

**Gateway HTTP** — request size limits (25MB audio, 2MB JSON), timeouts, admin tokens >= 32 random bytes, per-IP connection caps and auth failure throttling.

## Secrets

- your cloud credentials are used from your machine (bootstrap/destroy) and from the gateway's own instance role (operation). They are never sent to anything geniusrise operates.
- `deploy.yaml` is plaintext by design — it is yours. Use `${ENV}` references for hygiene.
- node join tokens are single-use with a 30-minute TTL; node certs come from a per-deployment CA; the gateway certificate is pinned by fingerprint on the node.
- API keys are stored hashed, compared in constant time.

## Privacy

Prompts, completions and audio are **never logged or stored**. The request log is a metadata-only ring buffer (key name, model, tokens, bytes, latency, status).

## Residual risks (documented honestly)

- spend is estimated, not invoiced; enforcement at 95% is the margin
- `sslip.io` + Let's Encrypt depends on a third-party DNS service — use a real domain for production
- Lambda/Hyperbolic account-wide firewall behavior may loosen the node lockdown
- community cloud on RunPod is multi-tenant hardware; opt-in only
