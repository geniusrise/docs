# Contributing recipes

Recipes live in `catalog/*.yaml` in the main repo. One file per model.

## Rules

1. **You must have actually run it.** Fill the `tested:` block with the date, provider, gpu and engine version. CI rejects recipes without it.
2. **Prefer tested quantized variants** — they are the cheap path for most operators (awq 8B fits an L4).
3. **Order `gpus` by preference** — the planner ranks the listed classes by price, but only the classes you list.
4. **Set a conservative `concurrency`** — it is the autoscaler target per replica.
5. Only LLM, STT and TTS. Only `vllm`, `llamacpp`, `speaches` engines for v1.

## PR process

- CI validates schema and the `tested:` block
- a maintainer may ask for the exact flags you used; put anything non-obvious in `args:`
- gpu smoke tests are manual for now: run the variant on the listed gpu class, hit `/health`, run one chat/audio request, then submit

## Example

```yaml
id: qwen2.5-7b-instruct
type: llm
license: apache-2.0
gated: false
default_variant: awq
variants:
  - name: awq
    engine: vllm
    hf_repo: Qwen/Qwen2.5-7B-Instruct-AWQ
    gpus: [L4, A10G, L40S]
    args: [--max-model-len, "16384", --gpu-memory-utilization, "0.92"]
    capacity: {concurrency: 32}
    tested: {date: "2026-10-01", provider: aws, gpu: L4, engine_version: "0.11.0"}
```
