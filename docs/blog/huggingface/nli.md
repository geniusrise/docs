# Host NLI Models Using Geniusrise

- [Host NLI Models Using Geniusrise](#host-nli-models-using-geniusrise)
  - [Setup and Configuration](#setup-and-configuration)
  - [Understanding Configuration Parameters](#understanding-configuration-parameters)
  - [Use Cases \& API Interaction](#use-cases--api-interaction)
    - [1. Entailment Checking](#1-entailment-checking)
    - [2. Classification](#2-classification)
    - [3. Textual Similarity](#3-textual-similarity)
    - [4. Fact Checking](#4-fact-checking)
    - [Customizing for Different NLI Models](#customizing-for-different-nli-models)
  - [Fun](#fun)
    - [Intent Tree Search](#intent-tree-search)
    - [Real-Time Debate Judging](#real-time-debate-judging)
    - [Automated Story Plot Analysis](#automated-story-plot-analysis)
    - [Customer Feedback Interpretation](#customer-feedback-interpretation)
    - [Virtual Courtroom Simulation](#virtual-courtroom-simulation)
  - [Play Around](#play-around)


Natural Language Inference (NLI) is like a game where you have to figure out if one sentence can logically follow from another or not. Imagine you hear someone say, "The dog is sleeping in the sun." Then, someone asks if it's true that "The dog is outside." In this game, you'd say "yes" because if the dog is sleeping in the sun, it must be outside. Sometimes, the sentences don't match up, like if someone asks if the dog is swimming. You'd say "no" because sleeping in the sun doesn't mean swimming. And sometimes, you can't tell, like if someone asks if the dog is dreaming. Since you don't know, you'd say "maybe." NLI is all about playing this matching game with sentences to help computers understand and use language like we do.

This post will explore setting up APIs for various NLI tasks using Geniusrise, including entailment, classification, textual similarity, and fact-checking. We’ll dive into the configuration details, provide interaction examples, and discuss how to tailor the setup for specific use cases.

## Setup and Configuration

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/jyvqfl2KCew?si=-kgGz9CbcduxCSxE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

**Requirements**

- python 3.10, [PPA](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa), [AUR](https://aur.archlinux.org/packages/python310), [brew](https://formulae.brew.sh/formula/python@3.10), [Windows](https://www.python.org/ftp/python/3.12.0/python-3.12.0b3-amd64.exe).
- You need to have a GPU. Most of the system works with NVIDIA GPUs.
- [Install CUDA](https://developer.nvidia.com/cuda-downloads).

Optional: Set up a virtual environment:

```bash
virtualenv venv -p `which python3.10`
source venv/bin/activate
```

**Installation:**

Start by installing Geniusrise and the necessary text processing extensions:

```bash
pip install geniusrise
pip install geniusrise-text
```

**Configuration (`genius.yml`):**

To deploy an NLI model, create a `genius.yml` configuration file:

```yaml
version: "1"

bolts:
    my_bolt:
        name: NLIAPI
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
            model_name: NDugar/ZSD-microsoft-v2xxlmnli
            model_class: AutoModelForSequenceClassification
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

Launch your API with the command:

```bash
genius rise
```

<iframe width="800" height="500" src="https://www.youtube-nocookie.com/embed/89ddLqYm5Qw?si=jYh-jjC3ftvIhhMF" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

## Understanding Configuration Parameters

- **model_name**: Identifies the pre-trained model from Hugging Face to be used.
- **use_cuda**: A boolean indicating whether to use GPU acceleration.
- **precision**: Determines the computational precision, affecting performance and resource usage.
- **device_map**: Specifies GPU allocation for model processing.
- **endpoint & port**: Network address and port for API access.
- **username & password**: Basic authentication credentials for API security.

## Use Cases & API Interaction

### 1. Entailment Checking

**Objective**: Assess whether a hypothesis is supported (entailment), contradicted (contradiction), or neither (neutral) by a premise.

**Using `curl`**:

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/entailment \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "premise": "This a very good entry level smartphone, battery last 2-3 days after fully charged when connected to the internet. No memory lag issue when playing simple hidden object games. Performance is beyond my expectation, i bought it with a good bargain, couldnt ask for more!",
        "hypothesis": "the phone has an awesome battery life"
    }' | jq
```

**Using `python-requests`**:

```python
import requests

data = {
  "premise": "This a very good entry level smartphone, battery last 2-3 days after fully charged when connected to the internet. No memory lag issue when playing simple hidden object games. Performance is beyond my expectation, i bought it with a good bargain, couldnt ask for more!",
  "hypothesis": "the phone has an awesome battery life"
}

response = requests.post("http://localhost:3000/api/v1/entailment",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

### 2. Classification

**Objective**: Classify a piece of text into predefined categories.

**Using `curl`**:

```bash
curl -X POST http://localhost:3000/api/v1/classify \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"text": "I love playing soccer.", "candidate_labels": ["sport", "cooking", "travel"]}'
```

**Using `python-requests`**:

```python
import requests

data = {
  "text": "I love playing soccer.",
  "candidate_labels": ["sport", "cooking", "travel"]
}

response = requests.post("http://localhost:3000/api/v1/classify",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

### 3. Textual Similarity

**Objective**: Determine the similarity score between two texts.

**Using `curl`**:

```bash
curl -X POST http://localhost:3000/api/v1/textual_similarity \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"text1": "I enjoy swimming.", "text2": "Swimming is my hobby."}'
```

**Using `python-requests`**:

```python
import requests

data = {
  "text1": "I enjoy swimming.",
  "text2": "Swimming is my hobby."
}

response = requests.post("http://localhost:3000/api/v1/textual_similarity",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

### 4. Fact Checking

**Objective**: Verify the accuracy of a statement based on provided context or reference material.

**Using `curl`**:

```bash
curl -X POST http://localhost:3000/api/v1/fact_checking \
     -H "Content-Type: application/json" \
     -u "user:password" \
     -d '{"context": "The Eiffel Tower is located in Paris.", "statement": "The Eiffel Tower is in France."}'
```

**Using `python-requests`**:

```python
import requests

data = {
  "context": "The Eiffel Tower is located in Paris.",
  "statement": "The Eiffel Tower is in France."
}

response = requests.post("http://localhost:3000/api/v1/fact_checking",
                         json=data,
                         auth=('user', 'password'))
print(response.json())
```

Each of these endpoints serves a specific NLI-related purpose, from evaluating logical relationships between texts to classifying and checking facts. By leveraging these APIs, developers can enhance their applications with deep, contextual understanding of natural language.

### Customizing for Different NLI Models

To deploy APIs for various NLI tasks, simply adjust the `model_name` in your `genius.yml`. For instance, to switch to a model optimized for textual similarity or fact-checking, replace `microsoft/deberta-v2-xlarge-mnli` with the appropriate model identifier.

## Fun

### Intent Tree Search

NLI when used for zero-shot classification can be used in a large number of contexts. Consider a chat usecase where there is an entire tree of possible scenarios, and you want to identify which node in the tree you're in to feed that particular prompt to another chat model.

Lets consider a 2-level tree such as this for an internal helpdesk:

```python
intents = {
    "IT Support": [
        "Computer or hardware issues",
        "Software installation and updates",
        "Network connectivity problems",
        "Access to digital tools and resources",
    ],
    "HR Inquiries": [
        "Leave policy and requests",
        "Benefits and compensation queries",
        "Employee wellness programs",
        "Performance review process",
    ],
    "Facilities Management": [
        "Workspace maintenance requests",
        "Meeting room bookings",
        "Parking and transportation services",
        "Health and safety concerns",
    ],
    "Finance and Expense": [
        "Expense report submission",
        "Payroll inquiries",
        "Budget allocation questions",
        "Procurement process",
    ],
    "Training and Development": [
        "Professional development opportunities",
        "Training program schedules",
        "Certification and learning resources",
        "Mentorship and coaching programs",
    ],
    "Project Management": [
        "Project collaboration tools",
        "Deadline extensions and modifications",
        "Resource allocation",
        "Project status updates",
    ],
    "Travel and Accommodation": [
        "Business travel arrangements",
        "Travel policy and reimbursements",
        "Accommodation bookings",
        "Visa and travel documentation",
    ],
    "Legal and Compliance": [
        "Contract review requests",
        "Data privacy and security policies",
        "Compliance training and certifications",
        "Legal consultation and support",
    ],
    "Communications and Collaboration": [
        "Internal communication platforms",
        "Collaboration tools and access",
        "Team meeting coordination",
        "Cross-departmental initiatives",
    ],
    "Employee Feedback and Suggestions": [
        "Employee satisfaction surveys",
        "Feedback submission channels",
        "Suggestion box for improvements",
        "Employee engagement activities",
    ],
    "Onboarding and Offboarding": [
        "New employee onboarding process",
        "Offboarding procedures",
        "Orientation schedules",
        "Transition support",
    ],
    "Administrative Assistance": [
        "Document and record-keeping",
        "Scheduling and calendar management",
        "Courier and mailing services",
        "Administrative support requests",
    ],
}
```

Lets deploy a large model so its more intelligent:

```yaml
version: "1"

bolts:
    my_bolt:
        name: NLIAPI
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
            model_name: facebook/bart-large-mnli
            model_class: AutoModelForSequenceClassification
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

we can browse through this tree to zero in on the user's micro-intent to retrieve our prompt to feed into the model:

```python
import requests

prompt =  "I need to travel to singapore next week 😃."

def find_most_probable_class(prompt, intents):
  response = requests.post("http://localhost:3000/api/v1/classify",
                          json={"text": prompt, "candidate_labels": intents},
                          auth=('user', 'password'))

  label_scores = response.json()["label_scores"]
  max_score = max(label_scores.values())
  chosen_label = [ k for k,v in label_scores.items() if v == max_score ][0]
  return chosen_label

level1 = find_most_probable_class(prompt, list(intents.keys()))
level2 = find_most_probable_class(prompt, list(intents[level1]))

print(f"The request is for department: {level1} and specifically for {level2}")

# The request is for department: Travel and Accommodation and specifically for Visa and travel documentation
```

### Real-Time Debate Judging

Imagine a scenario where an AI is used to judge a debate competition in real-time. Each participant's argument is evaluated for logical consistency, relevance, and how well it counters the opponent's previous points.

```python
debate_points = [
    {"speaker": "Alice", "statement": "Renewable energy can effectively replace fossil fuels."},
    {"speaker": "Bob", "statement": "Renewable energy is not yet reliable enough to meet all our energy needs."},
]

for i in range(1, len(debate_points)):
    premise = debate_points[i-1]["statement"]
    hypothesis = debate_points[i]["statement"]

    response = requests.post("http://localhost:3000/api/v1/entailment",
                             json={"premise": premise, "hypothesis": hypothesis},
                             auth=('user', 'password'))

    label_scores = response.json()["label_scores"]
    max_score = max(label_scores.values())
    chosen_label = [ k for k,v in label_scores.items() if v == max_score ][0]
    print(f"Debate point by {debate_points[i]['speaker']}: {hypothesis}")
    print(f"Judgement: {chosen_label}")

# Debate point by Bob: Renewable energy is not yet reliable enough to meet all our energy needs.
# Judgement: neutral
```

### Automated Story Plot Analysis

A model can be used to analyze a story plot to determine if the events and characters' decisions are logically consistent and plausible within the story's universe.

```python
story_events = [
    "The hero discovers a secret door in their house leading to a magical world.",
    "Despite being in a magical world, the hero uses their smartphone to call for help.",
    "The hero defeats the villain using a magical sword found in the new world.",
]

for i in range(1, len(story_events)):
    premise = story_events[i-1]
    hypothesis = story_events[i]

    response = requests.post("http://localhost:3000/api/v1/entailment",
                             json={"premise": premise, "hypothesis": hypothesis},
                             auth=('user', 'password'))
    label_scores = response.json()["label_scores"]
    if "neutral" in label_scores:
      del label_scores["neutral"]
    max_score = max(label_scores.values())
    chosen_label = [ k for k,v in label_scores.items() if v == max_score ][0]

    print(f"Story event - {chosen_label}: {hypothesis}")

# Story event - contradiction: Despite being in a magical world, the hero uses their smartphone to call for help.
# Story event - contradiction: The hero defeats the villain using a magical sword found in the new world.
```

### Customer Feedback Interpretation

This application involves analyzing customer feedback to categorize it into compliments, complaints, or suggestions, providing valuable insights into customer satisfaction and areas for improvement.

```python
feedbacks = [
    "The new update makes the app much easier to use. Great job!",
    "I've been facing frequent crashes after the last update.",
    "It would be great if you could add a dark mode feature.",
    "Otherwise you leave me no choice but to slowly torture your soul."
]

categories = ["compliment", "complaint", "suggestion", "murderous intent"]

for feedback in feedbacks:
    response = requests.post("http://localhost:3000/api/v1/classify",
                             json={"text": feedback, "candidate_labels": categories},
                             auth=('user', 'password'))
    label_scores = response.json()["label_scores"]
    max_score = max(label_scores.values())
    chosen_label = [ k for k,v in label_scores.items() if v == max_score ][0]

    print(f"Feedback - {chosen_label}: {feedback}")

# Feedback - suggestion: The new update makes the app much easier to use. Great job!
# Feedback - complaint: I've been facing frequent crashes after the last update.
# Feedback - suggestion: It would be great if you could add a dark mode feature.
# Feedback - murderous intent: Otherwise you leave me no choice but to slowly torture your soul.
```

### Virtual Courtroom Simulation

This is a game where players can simulate courtroom trials!
Players submit evidence and arguments, and the AI acts as the judge, determining the credibility and relevance of each submission to the case.

```python
courtroom_evidence = [
    {"evidence": "The defendant's fingerprints were found on the weapon."},
    {"evidence": "A witness reported seeing the defendant near the crime scene."},
]

for evidence in courtroom_evidence:
    submission = evidence["evidence"]

    response = requests.post("http://localhost:3000/api/v1/classify",
                             json={"text": submission, "candidate_labels": ["highly relevant", "relevant", "irrelevant"]},
                             auth=('user', 'password'))
    label_scores = response.json()["label_scores"]
    max_score = max(label_scores.values())
    chosen_label = [k for k, v in label_scores.items() if v == max_score][0]

    print(f"Evidence submitted: {submission}")
    print(f"Judged as: {chosen_label}")

# Evidence submitted: The defendant's fingerprints were found on the weapon.
# Judged as: highly relevant
# Evidence submitted: A witness reported seeing the defendant near the crime scene.
# Judged as: highly relevant
```

## Play Around

There are 218 models under "zero-shot-classification" on the [huggingface hub](https://huggingface.co/models?pipeline_tag=zero-shot-classification&sort=trending) but a simple search for `nli` turns up 822 models so there are a lot of models that are not tagged properly. NLI is a very interesting and a core NLP task and a few good general models can be turned into a lot of fun!
