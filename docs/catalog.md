# Models and catalog

Only models in the **curated catalog** can be deployed. Every entry is a tested recipe; PRs are welcome (see [contributing recipes](dev/recipes.md)).

```bash
geniusrise catalog            # list everything
geniusrise catalog whisper    # filter
```

## What a recipe looks like

```yaml
id: llama-3.1-8b-instruct
type: llm                 # llm | stt | tts
license: llama3.1
gated: true               # needs secrets.hf_token
default_variant: awq
variants:
  - name: awq
    engine: vllm          # vllm | llamacpp | speaches
    hf_repo: hugging-quants/Meta-Llama-3.1-8B-Instruct-AWQ-INT4
    gpus: [L4, A10G, L40S]
    args: [--max-model-len, "16384", --gpu-memory-utilization, "0.92"]
    capacity: {concurrency: 32}
    tested: {date: "2026-10-01", provider: aws, gpu: L4, engine_version: "0.11.0"}
```

- **engine** decides the serving runtime and the image. vLLM for GPU llms, llama.cpp for cpu/small-gpu llms (the homelab path), speaches for both audio directions.
- **gpus** is the tested preference order; the planner ranks these by live price for your capacity mode.
- **concurrency** is the autoscaler target per replica.
- **tested** is mandatory — CI rejects recipes without it.

## Choosing variants

Prefer quantized variants on small GPUs (`awq` fits an 8B model on an L4), fp16 when quality matters and you have the VRAM, `q4-cpu` for machines without GPUs.

## Custom catalogs

```
geniusrise plan --catalog https://your.org/geniusrise-catalog.yaml
```

A catalog is a list of recipes using the same schema; it is validated identically. This is how a community curates its own model list.
