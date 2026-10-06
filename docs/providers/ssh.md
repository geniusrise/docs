# SSH / bare metal

For homelabs, ISP boxes, university servers and any machines you can SSH into. No cloud account involved at all.

## deploy.yaml

```yaml
provider:
  type: ssh
  hosts:
    - {addr: 10.0.0.5, user: ubuntu, gpus: 2, cost_hr: 0.30}
    - {addr: 10.0.0.6, user: ubuntu, gpus: 1}
```

- `cost_hr` is your electricity/opex estimate; default 0. The budget is ignored on ssh.
- models must use cpu variants (`q4-cpu`, whisper-cpu, tts) — pick them explicitly; `plan --compare` switches variants automatically when pricing the ssh option.

## Host requirements

`geniusrise doctor ssh://user@host` checks:

- the NVIDIA driver (`nvidia-smi`) and Docker
- the nvidia container toolkit
- key auth works (`GR_SSH_KEY` overrides the key path, default `~/.ssh/id_ed25519` then `id_rsa`)

## What happens on apply

1. the CLI installs the gateway on the first host as a docker container (`gr-<name>-gateway`)
2. each host runs `geniusrise host join` as a systemd service — the **host agent**
3. the gateway asks host agents to start/stop engine containers, one per GPU (`docker run --gpus device=N`)

After the initial SSH, the gateway never needs SSH again: host agents dial out to the gateway over the reverse tunnel like every other node. That is also why NAT'd machines work.

## Set the host agent up

```bash
geniusrise host join http://<gateway>:443 <join-token>
```

The CLI does this over SSH during `apply`; you can also run it by hand. Wrap it in a systemd unit (`Restart=always`) so it survives reboots.
