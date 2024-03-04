# Host OCR Models Using Geniusrise

Optical Character Recognition (OCR) technology has revolutionized the way we process and digitize printed or handwritten documents, making it easier to edit, search, and store textual content in digital formats. Geniusrise facilitates the deployment of OCR models as APIs, enabling developers to integrate OCR capabilities into their applications seamlessly. This guide will demonstrate setting up OCR APIs using Geniusrise, covering the configuration, usage examples, and highlighting different use cases.

## Setup and Configuration

**Installation:**

First, install Geniusrise and its text extension:

```bash
pip install geniusrise
pip install geniusrise-vision
```

**Configuration (`genius.yml`):**

Create a `genius.yml` file to define your OCR service:

```yml
version: "1"

bolts:
    my_bolt:
        name: ImageOCRAPI
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
            model_name: facebook/bart-large-cnn
            model_class: AutoModelForSeq2SeqLM
            tokenizer_class: AutoTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

Activate your API with:

```bash
genius rise
```

## Configuration Parameters Explained

- **model_name**: Specifies the pre-trained model. For OCR tasks, models like `paddleocr`, `facebook/nougat-base`, or `easyocr` are popular choices.
- **use_cuda**: Enables GPU acceleration.
- **precision**: Affects performance through computational precision.
- **endpoint & port**: Network address and port for API access.
- **username & password**: Security credentials for API usage.

### Using PaddleOCR

PaddleOCR offers state-of-the-art accuracy and supports multiple languages, making it a great choice for applications requiring high-performance OCR.

#### `genius.yml` for PaddleOCR

```yaml
version: "1"

bolts:
    my_bolt:
        name: ImageOCRAPI
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
            model_name: "paddleocr"
            device_map: "cuda:0"
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: "http://localhost:3000"
            username: "user"
            password: "password"
```

This configuration sets up an OCR API using PaddleOCR. After setting up your `genius.yml`, activate your API by running:

```bash
genius rise
```

### Using EasyOCR

EasyOCR is a practical tool that supports more than 80 languages and doesn't require machine learning expertise to implement.

#### `genius.yml` for EasyOCR

```yaml
version: "1"

bolts:
    my_bolt:
        name: ImageOCRAPI
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
            model_name: "easyocr"
            device_map: "cuda:0"
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: "http://localhost:3000"
            username: "user"
            password: "password"
```

This YAML file configures an OCR API utilizing EasyOCR. Like with PaddleOCR, you'll need to execute `genius rise` to get the API running.

### General API Interaction Examples

Interacting with these OCR APIs can be done through HTTP requests, where you send a base64-encoded image and receive the detected text in response. Here's a generic example on how to send a request to either OCR API configured above:

#### Example with `curl`:

```bash
(base64 -w 0 path_to_your_image.jpg | awk '{print "{\"image_base64\": \""$0"\"}"}' > /tmp/image_payload.json)
curl -X POST http://localhost:3000/api/v1/ocr \
    -H "Content-Type: application/json" \
    -u user:password \
    -d @/tmp/image_payload.json | jq
```

#### Example with `python-requests`:

```python
import requests
import base64

with open("path_to_your_image.jpg", "rb") as image_file:
    image_base64 = base64.b64encode(image_file.read()).decode('utf-8')

data = {"image_base64": image_base64}

response = requests.post("http://localhost:3000/api/v1/ocr",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

## Interacting with the OCR API

OCR tasks involve converting images of text into editable and searchable data. Here's how to interact with the OCR API using `curl` and `python-requests`:

### Example with `curl`:

```bash
(base64 -w 0 your_image.jpg | awk '{print "{\"image_base64\": \""$0"\"}"}' > /tmp/image_payload.json)
curl -X POST http://localhost:3000/api/v1/ocr \
    -H "Content-Type: application/json" \
    -u user:password \
    -d @/tmp/image_payload.json | jq
```

### Example with `python-requests`:

```python
import requests
import base64

image_path = 'your_image.jpg'
with open(image_path, 'rb') as image_file:
    image_base64 = base64.b64encode(image_file.read()).decode('utf-8')

data = {
    "image_base64": image_base64
}

response = requests.post("http://localhost:3000/api/v1/ocr",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

## Use Cases & Variations

### Different OCR Models

To adapt the API for various OCR tasks, such as document digitization, receipt scanning, or handwritten note conversion, you can switch the `model_name` in your `genius.yml`:

- **Document OCR**: Use models like `paddleocr` for general document recognition.
- **Handwritten OCR**: Opt for models specifically fine-tuned for handwriting, such as `facebook/nougat-base`.
- **Receipt OCR**: Utilize domain-specific models designed for extracting information from receipts or invoices.

### Customizing OCR Parameters

For advanced OCR needs, additional parameters can be included in your request to customize the OCR process, such as specifying the language, adjusting the resolution, or defining the output format.
