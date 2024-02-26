# Host Table Question Answering Models Using Geniusrise

- [Host Table Question Answering Models Using Geniusrise](#host-table-question-answering-models-using-geniusrise)
  - [Setup and Configuration](#setup-and-configuration)
  - [Understanding `genius.yml` Parameters](#understanding-geniusyml-parameters)
  - [Use Cases \& Variations](#use-cases--variations)
    - [Changing the Model for Different Table QA Tasks](#changing-the-model-for-different-table-qa-tasks)
    - [Example `genius.yml` for tabular fact-checking:](#example-geniusyml-for-tabular-fact-checking)
  - [Interacting with Your API](#interacting-with-your-api)
    - [Table QA](#table-qa)
    - [Utilizing the Hugging Face Pipeline](#utilizing-the-hugging-face-pipeline)
  - [Fun](#fun)
    - [Executing SQL on data](#executing-sql-on-data)
    - [Query generators](#query-generators)
  - [Play around](#play-around)

Deploying table question answering (QA) models is a sophisticated task that Geniusrise simplifies for developers. This guide aims to demonstrate how you can use Geniusrise to set up and run APIs for table QA, a crucial functionality for extracting structured information from tabular data. We'll cover the setup process, explain the parameters in the `genius.yml` file with examples, and provide code snippets for interacting with your API using `curl` and `python-requests`.

## Setup and Configuration

**Requirements**

- You need to have a GPU. Most of the system works with NVIDIA GPUs.
- [Install CUDA](https://developer.nvidia.com/cuda-downloads).

Optional: Set up a virtual environment:

```bash
virtualenv venv
source venv/bin/activate
```

**Step 1: Install Geniusrise**

```bash
pip install geniusrise
pip install geniusrise-text
```

**Step 2: Configure Your API**

Create a `genius.yml` file to define the settings of your table QA API.

```yml
version: "1"

bolts:
    my_bolt:
        name: QAAPI
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
            model_name: google/tapas-base-finetuned-wtq
            model_class: AutoModelForTableQuestionAnswering
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

Launch your API with:

```bash
genius rise
```

## Understanding `genius.yml` Parameters

- **model_name**: The identifier for the model from Hugging Face, designed for table QA tasks.
- **model_class & tokenizer_class**: Specifies the classes used for the model and tokenizer, respectively, suitable for table QA.
- **use_cuda**: Utilize GPU acceleration to speed up inference times.
- **precision**: Determines the floating-point precision for calculations (e.g., `float` for single precision).
- **device_map**: Designates model parts to specific GPUs, optimizing performance.
- **endpoint & port**: The network address and port where the API will be accessible.
- **username & password**: Basic authentication credentials to secure access to your API.

## Use Cases & Variations

### Changing the Model for Different Table QA Tasks

To tailor your API for different table QA tasks, such as financial data analysis or sports statistics, you can modify the `model_name` in your `genius.yml`. For example, to switch to a model optimized for financial tables, you might use `google/tapas-large-finetuned-finance`.

### Example `genius.yml` for tabular fact-checking:

```yml
args:
  model_name: "google/tapas-large-finetuned-tabfact"
```

## Interacting with Your API

### Table QA

**Using `curl`:**

```bash
curl -X POST http://localhost:3000/api/v1/answer \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"question": "Who had the highest batting average?", "data": [{"player": "John Doe", "average": ".312"}, {"player": "Jane Roe", "average": ".328"}]}'
```

**Using `python-requests`:**

```python
import requests

data = {
  "question": "Who had the highest batting average?",
  "data": [
    {"player": "John Doe", "average": ".312"},
    {"player": "Jane Roe", "average": ".328"}
  ]
}

response = requests.post("http://localhost:3000/api/v1/answer",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

### Utilizing the Hugging Face Pipeline

Although primarily for text-based QA, you might experiment with the pipeline for preprocessing or extracting text from tables before querying.

**Using `curl`:**

```bash
curl -X POST http://localhost:3000/api/v1/answer_pipeline \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"question": "What is the total revenue?", "data": "The total revenue in Q1 was $10M, and in Q2 was $15M."}'
```

**Using `python-requests`:**

```python
import requests

data = {
  "question": "What is the total revenue?",
  "data": "

The total revenue in Q1 was $10M, and in Q2 was $15M."
}

response = requests.post("http://localhost:3000/api/v1/answer_pipeline",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

## Fun

Table QA is dominated by two families of base models: the google TAPAS and microsoft TAPEX.

### Executing SQL on data

Given some data and an sql query, this model can return the results.

```yml
version: "1"

bolts:
    my_bolt:
        name: QAAPI
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
            model_name: microsoft/tapex-large-sql-execution
            model_class: BartForConditionalGeneration
            tokenizer_class: TapexTokenizer
            use_cuda: true
            precision: float
            device_map: cuda:0
            endpoint: "0.0.0.0"
            port: 3000
            cors_domain: http://localhost:3000
            username: user
            password: password
```

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/answer \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "data": {
            "year": [1896, 1900, 1904, 2004, 2008, 2012],
            "city": ["athens", "paris", "st. louis", "athens", "beijing", "london"]
        },
        "question": "select year where city = beijing"
  }
  ' | jq

# {
#   "data": {
#     "year": [
#       1896,
#       1900,
#       1904,
#       2004,
#       2008,
#       2012
#     ],
#     "city": [
#       "athens",
#       "paris",
#       "st. louis",
#       "athens",
#       "beijing",
#       "london"
#     ]
#   },
#   "question": "select year where city = beijing",
#   "answer": {
#     "answers": [
#       "2008"        # <----
#     ],
#     "aggregation": "NONE"
#   }
# }
```

### Query generators

Given some data and a natural language query, these models generate a query that can be used to compute the result. These models are what power spreadsheet automations.

```yml
version: "1"

bolts:
    my_bolt:
        name: QAAPI
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
            model_name: google/tapas-large-finetuned-wtq
            model_class: AutoModelForTableQuestionAnswering
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

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/answer \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "data": {
          "population": ["10.6", "12.6", "12.9", "11.9", "10.3", "11.5", "12.5", "12.0", "11.5", "12.4", "11.0", "12.8", "12.5", "10.6", "11.9", "12.0", "12.6", "11.7", "12.3", "10.8", "11.2", "12.7", "10.5", "11.3", "12.2", "10.9", "11.7", "10.3", "10.9", "10.2", "10.6", "10.4", "10.5", "11.5", "11.7", "10.9", "10.4", "11.0", "12.4", "12.2", "11.3", "10.2", "11.0", "11.5", "11.0", "10.9", "11.5", "12.8", "11.3", "11.9", "12.9", "10.9", "11.4", "12.8", "10.3", "12.6", "11.1", "10.6", "12.0", "12.4", "10.2", "12.9", "11.7", "12.3", "12.4", "12.0", "10.9", "10.9", "12.3", "12.7", "10.2", "11.7", "12.4", "12.5", "12.0", "11.0", "12.9", "10.9", "10.4", "12.8", "10.3", "11.6", "12.9", "12.4", "12.4", "10.2", "11.2", "10.2", "10.1", "12.7", "11.2", "12.5", "11.7", "11.4", "10.7", "10.9", "11.5", "11.3", "10.3", "10.7", "11.2", "10.6", "11.0", "12.3", "11.7", "10.0", "10.4", "11.4", "11.5", "12.2"],
          "city": ["Tokyo", "Delhi", "Shanghai", "Sao Paulo", "Mumbai", "Mexico City", "Beijing", "Osaka", "Cairo", "New York", "Dhaka", "Karachi", "Buenos Aires", "Kolkata", "Istanbul", "Chongqing", "Lagos", "Rio de Janeiro", "Tianjin", "Kinshasa", "Guangzhou", "Los Angeles", "Moscow", "Shenzhen", "Lahore", "Bangalore", "Paris", "Bogota", "Jakarta", "Chennai", "Lima", "Bangkok", "Seoul", "Nagoya", "Hyderabad", "London", "Tehran", "Chicago", "Chengdu", "Nanjing", "Wuhan", "Ho Chi Minh City", "Luanda", "Ahmedabad", "Kuala Lumpur", "Riyadh", "Baghdad", "Santiago", "Surat", "Madrid", "Suzhou", "Pune", "Houston", "Dallas", "Toronto", "Dar es Salaam", "Miami", "Belo Horizonte", "Singapore", "Philadelphia", "Atlanta", "Fukuoka", "Khartoum", "Barcelona", "Johannesburg", "Saint Petersburg", "Qingdao", "Dalian", "Washington, D.C.", "Yangon", "Alexandria", "Jinan", "Guadalajara", "Harbin", "San Francisco", "Fort Worth", "Boston", "Detroit", "Montreal", "Porto Alegre", "Ankara", "Monterrey", "Nairobi", "Doha", "Luoyang", "Kuwait City", "Dublin", "Mecca", "Medina", "Amman", "Algiers", "Kampala", "Maputo", "Addis Ababa", "Brasilia", "Havana", "Faisalabad", "Tashkent", "Accra", "Sapporo", "Manila", "Hanoi", "Sydney", "Melbourne", "Cape Town", "Auckland", "Oslo", "Stockholm", "Helsinki", "Copenhagen"]
        },
        "question": "what is the total population of these cities"
  }
  ' | jq

# {
#   "data": {
#     "population": [ ...
#     ],
#     "city": [
#       "Tokyo", ...
#     ]
#   },
#   "question": "what is the total population of these cities",
#   "answer": {
#     "answers": [
#       "10.6",
#       ...
#       "12.2"
#     ],
#     "aggregation": "COUNT" # <---
#   }
# }
```

The `answer.aggregation` field indicates the operation to be done on the `answer.answers` field to get the answer.

However, when queries involve selecting one value from the data, the value of `answer.aggregation` remains as `NONE`.

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/answer \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
      "data": [
        {
          "Name": "Acme Corp",
          "Revenue": "1622908.31",
          "Expenses": "802256.16",
          "Profit": "820652.15",
          "Assets": "2758871.86",
          "Liabilities": "1786333.21",
          "Equity": "972538.65"
        },
        {
          "Name": "Globex Inc",
          "Revenue": "1846200.97",
          "Expenses": "1414781.1",
          "Profit": "431419.87",
          "Assets": "246642.65",
          "Liabilities": "1969146.36",
          "Equity": "-1722503.71"
        },
        {
          "Name": "Soylent Corp",
          "Revenue": "1585575.02",
          "Expenses": "1457030.2",
          "Profit": "128544.82",
          "Assets": "1599655.56",
          "Liabilities": "1260425.14",
          "Equity": "339230.42"
        },
        {
          "Name": "Initech LLC",
          "Revenue": "179462.76",
          "Expenses": "792898.88",
          "Profit": "-613436.12",
          "Assets": "780230.44",
          "Liabilities": "990416.97",
          "Equity": "-210186.53"
        },
        {
          "Name": "Umbrella Corp",
          "Revenue": "1882828.73",
          "Expenses": "487215.16",
          "Profit": "1395613.57",
          "Assets": "2933377.54",
          "Liabilities": "1519978.31",
          "Equity": "1413399.23"
        },
        {
          "Name": "Vandelay Ind",
          "Revenue": "1641614.11",
          "Expenses": "722957.57",
          "Profit": "918656.54",
          "Assets": "1818305.88",
          "Liabilities": "1051099.45",
          "Equity": "767206.43"
        },
        {
          "Name": "Hooli Inc",
          "Revenue": "784472.77",
          "Expenses": "1035568.89",
          "Profit": "-251096.12",
          "Assets": "1011898.52",
          "Liabilities": "757685.31",
          "Equity": "254213.21"
        },
        {
          "Name": "Stark Industries",
          "Revenue": "1752780.24",
          "Expenses": "954382.19",
          "Profit": "798398.05",
          "Assets": "1828265.8",
          "Liabilities": "1785958.67",
          "Equity": "42307.13"
        },
        {
          "Name": "Wayne Enterprises",
          "Revenue": "772662.41",
          "Expenses": "724219.29",
          "Profit": "48443.12",
          "Assets": "2952379.67",
          "Liabilities": "1255329.61",
          "Equity": "1697050.06"
        },
        {
          "Name": "Weyland-Yutani",
          "Revenue": "1157644.0",
          "Expenses": "1454230.66",
          "Profit": "-296586.66",
          "Assets": "776909.75",
          "Liabilities": "759733.68",
          "Equity": "17176.07"
        }
      ],
      "question": "Given the balance sheet data, identify the company with the highest equity to assets ratio."
}
' | jq

# {
#   "data": [
#     ...
#   ],
#   "question": "Given the balance sheet data, identify the company with the highest equity to assets ratio.",
#   "answer": {
#     "answers": [
#       "Wayne Enterprises"
#     ],
#     "aggregation": "NONE"
#   }
# }
```

Lets verify this:

```bash
def calculate_highest_equity_to_assets_ratio(data):
    ratios = {}
    for company in data["data"]:
        name = company["Name"]
        equity = float(company["Equity"])
        assets = float(company["Assets"])
        ratio = equity / assets if assets != 0 else 0
        ratios[name] = ratio

    highest_ratio_company = max(ratios, key=ratios.get)
    highest_ratio = ratios[highest_ratio_company]
    return highest_ratio_company, highest_ratio

highest_ratio_company, highest_ratio = calculate_highest_equity_to_assets_ratio(financial_data)
highest_ratio_company, highest_ratio
```

which gives us:

```bash
('Wayne Enterprises', 0.574807528057528)
```

yay 🥳

## Play around

This kind of models are few with 82 models on the [huggingface hub](https://huggingface.co/models?pipeline_tag=table-question-answering&p=1&sort=trending).
