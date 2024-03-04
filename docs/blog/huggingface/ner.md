# Host NER Models Using Geniusrise

Named Entity Recognition (NER) is a crucial task in natural language processing (NLP), enabling the identification of predefined categories such as the names of persons, organizations, locations, expressions of times, quantities, monetary values, percentages, etc. Geniusrise offers a streamlined approach to deploying NER models as APIs, facilitating the integration of sophisticated NER capabilities into applications. This guide explores setting up NER APIs using Geniusrise, covering various use cases and configurations.

## Quick Setup

**Installation:**

Ensure Geniusrise and its vision package are installed:

```bash
pip install geniusrise
pip install geniusrise-vision
```

**Configuration File (`genius.yml`):**

Craft a `genius.yml` for your NER API. Here's an example:

```yaml
version: "1"
bolts:
  my_bolt:
    name: NamedEntityRecognitionAPI
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
      model_name: "d4data/biomedical-ner-all"
      model_class: "AutoModelForTokenClassification"
      tokenizer_class: "AutoTokenizer"
      use_cuda: True
      precision: "float"
      device_map: "cuda:0"
      endpoint: "*"
      port: 3000
      cors_domain: "http://localhost:3000"
      username: "user"
      password: "password"
```

This setup configures an API for a biomedical NER model.

## Interacting with Your API

Extract named entities by making a POST request:

```bash
curl -X POST localhost:3000/api/v1/recognize_entities \
    -H "Content-Type: application/json" \
    -u user:password \
    -d '{"text": "Input text here."}' | jq
```

## Use Cases & Variations

### Biomedical NER

Deploy models like `d4data/biomedical-ner-all` for applications requiring identification of biomedical entities. This is useful for extracting specific terms from medical literature or patient records.

### Multilingual NER

For global applications, choose models supporting multiple languages, such as `Babelscape/wikineural-multilingual-ner`. This enables entity recognition across different languages, broadening your application's user base.

### Domain-Specific NER

Models like `pruas/BENT-PubMedBERT-NER-Gene` are tailored for specific domains (e.g., genetics). Using domain-specific models can significantly improve accuracy for targeted applications.

## Configuration Tips

- **Model Selection**: Evaluate different models to find the best match for your application's needs, considering factors like language, domain, and performance.
- **Precision and Performance**: Adjust `precision` and `use_cuda` settings based on your computational resources and response time requirements.
- **Security**: Implement basic authentication using `username` and `password` to protect your API.
