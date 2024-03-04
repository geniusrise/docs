# Host Segmentation Models Using Geniusrise

Segmentation models are pivotal in computer vision, allowing developers to delineate and understand the context within images by classifying each pixel into a set category. This capability is crucial for tasks ranging from autonomous driving to medical imaging. Geniusrise enables easy deployment of segmentation models as APIs, facilitating the integration of advanced vision capabilities into applications. This guide will demonstrate how to set up APIs for various segmentation tasks using Geniusrise, including semantic segmentation, panoptic segmentation, and instance segmentation.

## Setup and Configuration

**Installation:**

To begin, ensure that Geniusrise and its text extension are installed:

```bash
pip install geniusrise
pip install geniusrise-vision
```

**Configuration (`genius.yml`):**

Define your segmentation service in a `genius.yml` file. Here's an example for setting up a semantic segmentation model:

```yaml
version: "1"

bolts:
    my_bolt:
        name: VisionSegmentationAPI
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
            model_name: "facebook/mask2former-swin-large-ade-panoptic"
            model_class: "Mask2FormerForUniversalSegmentation"
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

Activate your API by running:

```bash
genius rise
```

## Configuration Parameters Explained

- **model_name**: The pre-trained model identifier, adaptable based on the segmentation task (semantic, panoptic, instance).
- **model_class & processor_class**: Specify the model and processor classes, essential for interpreting and processing images.
- **device_map & use_cuda**: Configure GPU acceleration for enhanced processing speed.
- **endpoint, port, username, & password**: Network settings and authentication for API access.

## Interacting with the Segmentation API

The interaction involves sending a base64-encoded image to the API and receiving segmented output. Here's how to execute this using `curl` and `python-requests`:

### Example with `curl`:

```bash
(base64 -w 0 your_image.jpg | awk '{print "{\"image_base64\": \""$0"\", \"subtask\": \"semantic\"}"}' > /tmp/image_payload.json)
curl -X POST http://localhost:3000/api/v1/segment_image \
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

data = {
    "image_base64": image_base64,
    "subtask": "semantic"  # or "panoptic" for panoptic segmentation
}

response = requests.post("http://localhost:3000/api/v1/segment_image",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

## Use Cases & Variations

### Different Segmentation Tasks

By modifying the `subtask` parameter, you can tailor the API for various segmentation models:

- **Semantic Segmentation**: Classifies each pixel into a predefined category. Useful in urban scene understanding and medical image analysis.
- **Panoptic Segmentation**: Combines semantic and instance segmentation, identifying and delineating each object instance. Ideal for detailed scene analysis.
- **Instance Segmentation**: Identifies each instance of each object category. Used in scenarios requiring precise object boundaries.

### Customizing Segmentation Parameters

For advanced segmentation needs, additional parameters can be included in your request to customize the processing, such as specifying the output resolution or the segmentation task (semantic, panoptic, instance).

