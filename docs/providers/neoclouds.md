# Lambda and Hyperbolic

Phase 3. GPU-only clouds: no cheap CPU instances for the gateway, so `gateway.host` is **required**:

```yaml
provider:
  type: lambda        # or hyperbolic
  region: us-east-1
gateway:
  host: ssh://ubuntu@my-vps.example.com
```

Point it at any always-on box you control (a VPS, your homelab). It runs the gateway exactly like the ssh provider's first host.

## Known limitations

- Lambda firewall rules apply account-wide and instances get an SSH key by default; nodes cannot be locked down as tightly as the baseline. The docs will state the residual exposure once P3 verification lands.
