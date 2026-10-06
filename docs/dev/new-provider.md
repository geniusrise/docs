# Adding a provider

A provider is a small adapter: provision capacity, boot a container, tear it down, report price.

```go
type Provider interface {
    Bootstrap(ctx, DeploymentSpec, BootstrapOpts) (GatewayInfo, error) // CLI-side, local creds
    Offerings(ctx, region) ([]Offering, error)                          // gpu class -> instance type + live price
    Launch(ctx, NodeSpec) (Node, error)                                 // gateway-side
    List(ctx, deployment) ([]Node, error)
    Terminate(ctx, NodeID) error
    Destroy(ctx, DeploymentSpec) error
}
```

## Rules

1. **Idempotent creates.** Every create is get-or-create by name `gr-<deployment>-*` or tag `geniusrise:deployment`.
2. **Tag everything.** `Destroy` and orphan cleanup only touch tagged/prefixed resources — the user's account must be safe by construction.
3. **Minimum footprint.** Default network, no managed k8s, no NAT gateways, no load balancers. If a provider lacks small CPU instances, require `gateway.host` instead.
4. **Nodes dial out.** The tunnel expects nodes behind NAT/firewalls; never require inbound node ports.
5. **Price your offerings** from a public API where one exists, and add the fetcher to `tools/pricegen`.

## Checklist for a new provider

- [ ] adapter in `internal/provider/<name>/`
- [ ] unit tests for user-data/script rendering and any pure helpers
- [ ] offerings in `tools/pricegen` + embedded fallback entry
- [ ] contract suite passes against the fake, then `make e2e PROVIDER=<name>`
- [ ] `spec.Validate` error messages for provider-specific requirements (like `gateway.host`)
- [ ] docs page under `docs/providers/`
