# AWS

The AWS provider uses the **default VPC** and public subnets. No new VPCs, no NAT gateways, no EKS, no load balancers.

## What gets created

| resource | purpose |
|---|---|
| security group `gr-<name>-gw` | inbound 443 to the gateway |
| security group `gr-<name>-node` | **no inbound rules at all** |
| IAM role + policy + profile `gr-<name>-gw-role` | gateway only: RunInstances, TerminateInstances, Describe*, PassRole, pricing:GetProducts |
| elastic IP | stable gateway address (`<ip-dashed>.sslip.io`) |
| `t4g.micro` gateway instance + 12GB gp3 root | runs the gateway container; ~$11/month floor |
| GPU node instances | DLAMI base (CUDA driver + docker), spot when requested, IMDSv2 required, no SSH keypair |

Everything carries `geniusrise:deployment=<name>`. `destroy` deletes by tag and name prefix only.

## Node boot

cloud-init runs a single `docker run --gpus all --restart always` of the engine image with the join token in env. Nodes have no IAM role — they need no cloud permissions.

## Quotas

Most new accounts start with **zero G/VT vCPU quota**. `geniusrise doctor` checks L-417A185B (on-demand) and L-3819A6DF (spot) and prints the increase request link.

## No default VPC?

If your account has no default VPC, create one or set `provider.subnet` explicitly.
