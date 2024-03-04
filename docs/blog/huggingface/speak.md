# Host Text to Speech Models Using Geniusrise

Text to Speech (TTS) technology has transformed how we interact with digital devices, making information more accessible and enhancing user experiences. Geniusrise simplifies the deployment of TTS models as APIs, allowing developers to incorporate high-quality voice synthesis into their applications. This guide focuses on setting up TTS APIs with Geniusrise, showcasing various use cases and providing examples to help you get started.

## Quick Setup

**Installation:**

Begin by installing Geniusrise and its dependencies:

```bash
pip install geniusrise
pip install geniusrise-vision
```

**Configuration File (`genius.yml`):**

Define your TTS API using a `genius.yml` file. Here's a basic example:

```yaml
version: "1"
bolts:
  my_bolt:
    name: TextToSpeechAPI
    state:
      type: none
    input:
      type: batch
      args:
        input_folder: ./input
    output:
      type: batch
      args:
        output_folder: ./output
    method: listen
    args:
      model_name: "facebook/mms-tts-eng"
      model_class: "VitsModel"
      processor_class: "VitsTokenizer"
      use_cuda: True
      precision: "float32"
      device_map: "cuda:0"
      endpoint: "*"
      port: 3000
      cors_domain: "http://localhost:3000"
      username: "user"
      password: "password"
```

This configuration sets up an API for Facebook's MMS TTS English model.

## Interacting with Your API

Convert text to speech by making a POST request to your API. Here's how to do it using `curl`:

```bash
curl -X POST localhost:3000/api/v1/synthesize \
    -H "Content-Type: application/json" \
    -u user:password \
    -d '{"text": "Your text here.", "output_type": "mp3"}' \
    | jq -r '.audio_file' | base64 -d > output.mp3 && vlc output.mp3
```

## Use Cases & Variations

### Multilingual Support

Deploy models capable of synthesizing speech in multiple languages. Modify the `model_name` and add `tgt_lang` parameters to target different languages.

### Voice Personalization

Some models support different voice presets. Use the `voice_preset` parameter to select various voices, adjusting tone and style to fit your application's context.

### High-Quality Synthesis

For applications requiring high-fidelity audio, select models optimized for quality, such as `facebook/seamless-m4t-v2-large`. These models often have larger sizes but produce more natural and clear voice outputs.

### Real-Time Applications

For real-time TTS needs, focus on models with lower latency. Configuration options like `use_cuda` for GPU acceleration and `precision` adjustments can help reduce response times.

## Configuration Tips

- **Model Selection**: Experiment with various models to find the best fit for your application's language, quality, and performance requirements.
- **Security**: Use the `username` and `password` fields to secure your API endpoint.
- **Resource Management**: Adjust `precision`, `quantization`, and `device_map` settings based on your server's capabilities and your application's needs.

