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

(like docker-compose etc).

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
