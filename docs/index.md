# geniusrise

Run open **LLM**, **speech-to-text** and **text-to-speech** models on infrastructure you control — a cloud account or your own machines — with one binary and one yaml file.

```bash
curl -fsSL https://geniusrise.com/install.sh | sh
geniusrise init
geniusrise plan
geniusrise apply
```

You get one OpenAI-compatible HTTPS endpoint that:

- picks the most optimized tested runtime per model (vLLM, llama.cpp, speaches)
- autoscales with scale-to-zero, inside a hard monthly budget
- authenticates users with API keys and per-key limits
- stores nothing about you anywhere except your own infrastructure

Start with the [quickstart](quickstart.md). The design is documented in [architecture](architecture.md) and [security](security.md).
