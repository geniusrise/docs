# Host Image Classification Models Using Geniusrise

Image classification is a cornerstone of machine learning and computer vision, providing the backbone for a myriad of applications from photo organization to medical imaging. With Geniusrise, developers can effortlessly deploy image classification models as APIs, making these powerful tools accessible for integration into various applications. This guide highlights the process of setting up image classification APIs using Geniusrise, offering a range of use cases and configurations.

## Quick Setup

**Installation:**

To start, ensure Geniusrise and its text extension are installed:

```bash
pip install geniusrise
pip install geniusrise-vision
```

**Configuration File (`genius.yml`):**

Your `genius.yml` configuration will outline the API's structure. Below is a template adjusted for image classification:

```yaml
version: "1"

bolts:
    my_bolt:
        name: ImageClassificationAPI
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
            model_name: "google/vit-base-patch16-224"
            model_class: "AutoModelForImageClassification"
            processor_class: "AutoImageProcessor"
            device_map: "cuda:0"
            use_cuda: true
            precision: "float"
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: "http://localhost:3000"
            username: "user"
            password: "password"
```

Activate your API by executing:

```bash
genius rise
```

## Configuration Parameters Explained

- **model_name**: Defines the pre-trained model used for classification. Choices vary based on the application, from generic models like Google's ViT to specialized ones for food or NSFW detection.
- **model_class & processor_class**: Specifies the model and processor classes for handling image data.
- **device_map & use_cuda**: Configures GPU usage for enhanced performance.
- **endpoint, port, username, & password**: Details for accessing the API securely.

## Interacting with the Image Classification API

### Example with `curl`:

```bash
(base64 -w 0 your_image.jpg | awk '{print "{\"image_base64\": \""$0"\"}"}' > /tmp/image_payload.json)
curl -X POST http://localhost:3000/api/v1/classify_image \
    -H "Content-Type: application/json" \
    -u user:password \
    -d @/tmp/image_payload.json | jq
```

### Example with `python-requests`:

```python
import requests
import base64

with open("your_image.jpg", "rb") as image_file:
    image_base64 = base64.b64encode(image_file.read()).decode('utf-8')

data = {"image_base64": image_base64}

response = requests.post("http://localhost:3000/api/v1/classify_image",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

## Use Cases & Variations

### Different Image Classification Models

Tailor your API for a variety of classification tasks by selecting appropriate models:

- **Aesthetic Assessment**: Use models like `cafeai/cafe_aesthetic` to classify images based on aesthetic qualities.
- **Gender Classification**: Apply models such as `rizvandwiki/gender-classification` for gender recognition.
- **Food Recognition**: Employ food-specific models like `nateraw/food` to categorize food items.
- **Object Detection**: Utilize models like `microsoft/ResNet-50` for broad object classification.
- **NSFW Detection**: Choose models designed for NSFW content detection, ensuring user-generated content is appropriate.

### Customizing Classification Parameters

For advanced needs, include additional parameters in your request to customize the classification, such as the confidence threshold or specific labels to focus on.
