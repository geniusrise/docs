# Azure

Phase 2. Everything lives in one resource group `gr-<name>`, so destroy is a single deletion:

- vnet + two NSGs (gateway: 443 in; nodes: deny all inbound)
- gateway: `B1s` with a managed identity that is **Contributor on that resource group only**
- spot via priority Spot with eviction policy Delete
- nodes use Ubuntu HPC/DSVM images (driver + docker)

## Notes

- Azure is retiring default outbound internet access for new vnets; each node gets its own public IP with a deny-all NSG, which is cheaper than a NAT gateway and keeps the "no extra fat" rule.
- vCPU quota per family must be requested; `doctor` surfaces the exact family.
