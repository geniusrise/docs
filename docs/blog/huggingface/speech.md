# Host Speech to Text Models Using Geniusrise

Speech to Text (STT) technology has become a cornerstone in creating accessible and efficient user interfaces. Geniusrise offers a streamlined approach to deploying STT models as APIs, enabling developers to integrate speech recognition capabilities into their applications with ease. This post will guide you through setting up STT APIs using Geniusrise, highlighting various use cases and providing practical examples.

## Quick Setup

**Installation:**

Before you start, make sure you have Geniusrise installed:

```bash
pip install geniusrise
pip install geniusrise-vision
```

**Configuration File (`genius.yml`):**

Create a `genius.yml` configuration file to define your STT API's specifications. Here’s an example configuration:

```yaml
version: "1"
bolts:
  my_bolt:
    name: SpeechToTextAPI
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
      model_name: "openai/whisper-large-v3"
      model_class: "WhisperForConditionalGeneration"
      processor_class: "AutoProcessor"
      use_cuda: True
      precision: "float32"
      device_map: "cuda:0"
      endpoint: "*"
      port: 3000
      cors_domain: "http://localhost:3000"
      username: "user"
      password: "password"
```

This configuration launches an STT API using OpenAI's Whisper model.

## API Interaction

To interact with your STT API, encode your audio file in base64 format and construct a JSON payload. Below are examples using `curl`:

```bash
# Encode your audio file to base64 and create the payload
base64 -w 0 sample.mp3 | awk '{print "{\"audio_file\": \""$0"\", \"model_sampling_rate\": 16000}"}' > payload.json

# Send the request to your API
curl -X POST http://localhost:3000/api/v1/transcribe \
     -H "Content-Type: application/json" \
     -u user:password \
     -d @payload.json | jq
```

## Use Cases & Variations

### General Speech Recognition

Deploy models like `openai/whisper-large-v3` for broad speech recognition tasks across various languages and domains.

### Specialized Transcription

For specialized domains, such as medical or legal transcription, tailor your `genius.yml` to utilize domain-specific models to improve accuracy.

### Long Audio Files

Handling long audio files efficiently requires chunking the audio into manageable pieces. Adjust `chunk_size` in your configuration to enable this feature.

### Real-time Transcription

For real-time applications, consider models optimized for speed and responsiveness. Adjust `endpoint`, `port`, and `device_map` accordingly to minimize latency.

## Advanced Configuration Tips

- **Model Selection**: Experiment with different models to find the one that best suits your needs. Geniusrise supports a wide range of STT models.
- **Precision and Performance**: Adjust the `precision` and `use_cuda` settings to balance between transcription accuracy and resource utilization.
- **Security**: Use `username` and `password` in your configuration to secure your API endpoint.
