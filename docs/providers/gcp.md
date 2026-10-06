# GCP

Phase 2. Same minimal pattern as AWS:

- firewall rule allowing 443 to the gateway tag, and a **deny-all inbound** rule at priority 100 for node tags (this overrides the default network's open SSH/RDP rules — important)
- a gateway service account restricted by IAM condition to resources named `gr-<deployment>-*`
- static IP; `e2-micro` gateway (free tier in US regions)
- spot via `provisioningModel: SPOT`
- nodes use the Deep Learning VM image (driver + docker)

## Notes

- GCP regional GPU quota must be requested before first apply; `doctor` surfaces it.
- e2-micro free tier makes the gateway floor cost $0 in us regions (IP excluded).
