# Usage

The easiest way to use geniusrise is to host an API over a desired model.
Use one of the examples from [text](https://github.com/geniusrise/examples/tree/master/cli/api/text), [vision](https://github.com/geniusrise/examples/tree/master/cli/api/vision) or [audio](https://github.com/geniusrise/examples/tree/master/cli/api/audio).

## Run on Local

Say, we are interested in running an API over a vision / multi-modal model such as [bakLlava from huggingface](https://huggingface.co/llava-hf/bakLlava-v1-hf):

### 1. Install geniusrise and vision

```bash
pip install geniusrise
pip install geniusrise-vision # vision multi-modal models
# pip install geniusrise-text # text models, LLMs
# pip install geniusrise-audio # audio models
```

### 2. Use the genius cli to run bakLlava

```bash
genius VisualQAAPI rise \
    batch \
        --input_folder ./input \
    batch \
        --output_folder ./output \
    none \
    listen \
        --args \
            model_name="llava-hf/bakLlava-v1-hf" \
            model_class="LlavaForConditionalGeneration" \
            processor_class="AutoProcessor" \
            device_map="cuda:0" \
            use_cuda=True \
            precision="bfloat16" \
            quantization=0 \
            max_memory=None \
            torchscript=False \
            compile=False \
            flash_attention=False \
            better_transformers=False \
            endpoint="*" \
            port=3000 \
            cors_domain="http://localhost:3000" \
            username="user" \
            password="password"
```

### 3. Test the API

```bash
MY_IMAGE=/path/to/test/image

(base64 -w 0 $MY_IMAGE | awk '{print "{\"image_base64\": \""$0"\", \"question\": \"<image>\nUSER: Whats the content of the image?\nASSISTANT:\", \"do_sample\": false, \"max_new_tokens\": 128}"}' > /tmp/image_payload.json)
curl -X POST http://localhost:3000/api/v1/answer_question \
    -H "Content-Type: application/json" \
    -u user:password \
    -d @/tmp/image_payload.json | jq
```

### 4. Save your work

Save what you did to be replicated later as `genius.yml` file:

```yaml
version: '1'

bolts:
    my_bolt:
        name: VisualQAAPI
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
            model_name: 'llava-hf/bakLlava-v1-hf'
            model_class: 'LlavaForConditionalGeneration'
            processor_class: 'AutoProcessor'
            device_map: 'cuda:0'
            use_cuda: True
            precision: 'bfloat16'
            quantization: 0
            max_memory: None
            torchscript: False
            compile: False
            flash_attention: False
            better_transformers: False
            endpoint: '*'
            port: 3000
            cors_domain: 'http://localhost:3000'
            username: 'user'
            password: 'password'
```

To later re-run the same, simply navigate to the directory of this file and do:

```bash
genius rise
```

## Advanced Usage

For having a set of APIs, say for voice -> text -> text -> voice pipeline, create a `genius.yml` file like this:

```yaml
version: "1"

bolts:
    speech_to_text_bolt:
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
            model_name: openai/whisper-large-v3
            model_class: WhisperForConditionalGeneration
            processor_class: AutoProcessor
            use_cuda: true
            precision: float
            quantization: 0
            device_map: cuda:0
            max_memory: null
            torchscript: false
            compile: false
            flash_attention: False
            better_transformers: False
            endpoint: "0.0.0.0"
            port: 3001
            cors_domain: http://localhost:3001
            username: user
            password: password

    chat_bolt:
        name: InstructionAPI
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
            model_name: TheBloke/Mistral-7B-Instruct-v0.1-GPTQ:gptq-4bit-32g-actorder_True
            model_class: AutoModelForCausalLM
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float16
            quantization: 0
            device_map: auto
            max_memory: null
            torchscript: false
            compile: false
            flash_attention: False
            better_transformers: False
            awq_enabled: False
            endpoint: "0.0.0.0"
            port: 3002
            cors_domain: http://localhost:3002
            username: user
            password: password

    text_to_speech_bolt:
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
            model_name: suno/bark
            model_class: BarkModel
            processor_class: BarkProcessor
            use_cuda: true
            precision: float32
            quantization: 0
            device_map: cuda:0
            max_memory: null
            torchscript: false
            compile: false
            flash_attention: False
            better_transformers: False
            endpoint: "0.0.0.0"
            port: 3003
            cors_domain: http://localhost:3003
            username: user
            password: password
```

and run:

```bash
genius rise
```

(like docker-compose etc).

then try it out:

```bash
# Step 1: Transcribe audio file
TRANSCRIPTION=$(echo $(base64 -w 0 sample.mp3) | awk '{print "{\"audio_file\": \""$0"\", \"model_sampling_rate\": 16000}"}' | \
    curl -s -X POST http://localhost:3001/api/v1/transcribe \
    -H "Content-Type: application/json" \
    -u user:password \
    -d @- | jq -r '.transcriptions.transcription')
echo "Transcription: $TRANSCRIPTION"

# Step 2: Send a prompt to the text completion API
PROMPT_JSON=$(jq -n --arg prompt "$TRANSCRIPTION" '{"prompt": $prompt, "decoding_strategy": "generate", "max_new_tokens": 100, "do_sample": true, "pad_token_id": 0}')
COMPLETION=$(echo $PROMPT_JSON | curl -s -X POST "http://localhost:3002/api/v1/complete" \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d @- | jq -r '.completion')
echo "Completion: $COMPLETION"

# Step 3: Synthesize speech from text and play the output
SYNTH_JSON=$(jq -n --arg text "$COMPLETION" '{"text": $text, "output_type": "mp3", "voice_preset": "v2/en_speaker_6"}')
curl -s -X POST "http://localhost:3003/api/v1/synthesize" \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d "$SYNTH_JSON" | jq -r '.audio_file' | base64 -d > output.mp3

vlc output.mp3 &>/dev/null
```

## Run on Remote

If we are running on a remote machine instead, perhaps we want to use our own model stored in S3?

```bash
genius VisualQAAPI rise \
    batch \
        --input_s3_bucket my-s3-bucket \
        --input_s3_folder model \
    batch \
        --output_s3_bucket my-s3-bucket \
        --output_s3_folder output-<partition/keys> \
    none \
    listen \
        --args \
            model_name="local" \
            model_class="LlavaForConditionalGeneration" \
            processor_class="AutoProcessor" \
            device_map="cuda:0" \
            use_cuda=True \
            precision="bfloat16" \
            quantization=0 \
            max_memory=None \
            torchscript=False \
            compile=False \
            flash_attention=False \
            better_transformers=False \
            endpoint="*" \
            port=3000 \
            cors_domain="http://localhost:3000" \
            username="user" \
            password="password"
```

or in YAML:

```yaml
version: '1'

bolts:
    my_bolt:
        name: VisualQAAPI
        state:
            type: none
        input:
            type: batch
            args:
                bucket: my-s3-bucket
                folder: model
        output:
            type: batch
            args:
                bucket: my-s3-bucket
                folder: output-<partition/keys>
        method: listen
        args:
            model_name: 'llava-hf/bakLlava-v1-hf'
            model_class: 'LlavaForConditionalGeneration'
            processor_class: 'AutoProcessor'
            device_map: 'cuda:0'
            use_cuda: True
            precision: 'bfloat16'
            quantization: 0
            max_memory: None
            torchscript: False
            compile: False
            flash_attention: False
            better_transformers: False
            endpoint: '*'
            port: 3000
            cors_domain: 'http://localhost:3000'
            username: 'user'
            password: 'password'
```

## Docker packaging

Perhaps we also want to now use docker to package?

Refer [**Packaging**](guides/packaging.md)

## To Production

And finally deploy as a replicaset on a kubernetes cluster for going to prod!

Refer [**Deployment**](guides/deployment.md)

## Observability

We have prometheus integrated, just integrate with your prometheus cluster!
Prometheus runs on `PROMETHEUS_PORT` ENV variable or `8282` by default.
