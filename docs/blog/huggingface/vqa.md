# Host Visual QA Models Using Geniusrise

Visual Question Answering (VQA) combines the power of visual understanding with natural language processing to answer questions about images. Geniusrise offers a streamlined process to deploy VQA models as APIs, making it accessible to developers to integrate advanced AI capabilities into their applications. This blog post demonstrates how to set up VQA APIs using Geniusrise and provides examples for various use cases.

## Setting Up

To begin, ensure you have Geniusrise and Geniusrise-Vision installed:

```bash
pip install geniusrise
pip install geniusrise-vision
```

Create a `genius.yml` configuration file tailored to your API requirements, specifying the model, tokenizer, and additional parameters necessary for inference.

## Sample Configuration

Below is an example of a configuration file for a VQA API:

```yaml
version: "1"
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
      model_name: "google/pix2struct-ai2d-base"
      model_class: "Pix2StructForConditionalGeneration"
      processor_class: "Pix2StructProcessor"
      use_cuda: true
      precision: "float"
      device_map: "cuda:0"
      endpoint: "*"
      port: 3000
      cors_domain: "http://localhost:3000"
      username: "user"
      password: "password"
```

This configuration sets up a VQA API using the Pix2Struct model, ready to process images and answer questions about them.

## Interacting with Your API

To interact with your VQA API, encode your images in base64 format and construct a JSON payload with the image and the question. Here are examples using `curl`:

```bash
# Convert the image to base64 and prepare the payload
base64 -w 0 image.jpg | awk '{print "{\"image_base64\": \""$0"\", \"question\": \"What is in this image?\"}"}' > payload.json

# Send the request to your API
curl -X POST http://localhost:3000/api/v1/answer_question \
     -H "Content-Type: application/json" \
     -u user:password \
     -d @payload.json | jq
```

## Use Cases & Variations

### General VQA

Use models like `google/pix2struct-ai2d-base` for general VQA tasks, where the model predicts answers based on the image content and the posed question.

### Specialized VQA

For specialized domains, such as medical imaging or technical diagrams, tailor your `genius.yml` to use domain-specific models. This requires replacing the `model_name`, `model_class`, and `processor_class` with those suitable for your specific application.

### Advanced Configuration

Experiment with different models, precision levels, and CUDA settings to optimize performance and accuracy for your use case. Geniusrise allows for detailed configuration, including quantization and torchscript options, to fine-tune the deployment according to your requirements.
