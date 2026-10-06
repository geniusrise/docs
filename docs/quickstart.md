# Quickstart

This page takes a standard IT generalist from zero to a working endpoint.

## 1. Install

```bash
curl -fsSL https://geniusrise.com/install.sh | sh
geniusrise --version
```

Linux and macOS, amd64 and arm64. Or build from source: `go install github.com/geniusrise/geniusrise/cmd/geniusrise@latest`.

## 2. Create the deployment file

```bash
geniusrise init
```

Answer four questions (name, provider, region, budget) and you get a `deploy.yaml`. A complete example:

```yaml
version: 1
name: acme-ai
provider:
  type: aws
  region: us-east-1
  capacity: spot-fallback
budget:
  monthly_usd: 500
models:
  - id: llama-3.1-8b-instruct
    variant: awq
    replicas: {min: 0, max: 4}
    idle_timeout: 15m
  - id: whisper-large-v3-turbo
    replicas: {min: 1, max: 2}
  - id: kokoro-82m
keys:
  - name: alice
    key: ${ALICE_KEY}
    limits: {rpm: 60, tokens_per_day: 200000, stt_mb_per_day: 200}
secrets:
  hf_token: ${HF_TOKEN}
```

## 3. Check the plan

```bash
geniusrise plan            # placement and monthly cost
geniusrise plan --compare  # same yaml priced on every provider
```

Comparing needs no cloud account — prices come from the public daily snapshot.

## 4. Credentials and quotas

For AWS: `aws configure` (or standard `AWS_*` env vars). Then:

```bash
geniusrise doctor
```

New cloud accounts often ship with **zero GPU quota**. Doctor prints the exact quota increase request to file.

## 5. Apply

```bash
geniusrise apply
```

First run bootstraps the gateway (a tiny VM in the region — see [providers](providers/aws.md) for exactly what gets created), then pushes your config. `apply` writes `gateway.url` and `gateway.admin_token` back into `deploy.yaml`.

## 6. Use it

```bash
curl https://<your-gateway>/v1/chat/completions \
  -H "Authorization: Bearer $ALICE_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model": "llama-3.1-8b-instruct", "messages": [{"role": "user", "content": "hello"}]}'
```

Any OpenAI-compatible client works: Open WebUI, LibreChat, curl, your code. Audio uses the OpenAI shapes `/v1/audio/transcriptions` and `/v1/audio/speech`.

## 7. Maintain

Editing the model list, limits or budget and re-running `geniusrise apply` is the entire maintenance surface. Watch spend with `geniusrise status`.

## 8. Remove everything

```bash
geniusrise destroy
```

Terminates every node, the gateway, and every tagged resource we own.
