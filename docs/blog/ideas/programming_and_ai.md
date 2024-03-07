# Mixing AI and programming

- [Mixing AI and programming](#mixing-ai-and-programming)
    - [Practical basics of a programming language](#practical-basics-of-a-programming-language)
    - [If conditions](#if-conditions)
        - [Zero-shot if conditions](#zero-shot-if-conditions)
        - [Zero-shot if conditions on images](#zero-shot-if-conditions-on-images)
    - [Loops](#loops)
        - [AI-powered loop conditions](#ai-powered-loop-conditions)
    - [Exception handling](#exception-handling)
    - [Functions](#functions)
        - [Adaptive functions](#adaptive-functions)
        - [Auto-generated mapping functions / soft-composition](#auto-generated-mapping-functions--soft-composition)
    - [Conclusion](#conclusion)


The new era of AI models (and they can be finally called "AI" instead of the earlier "ML"), has brought in a new era of capabilities that we are still in the teethhing stages trying to explore.

This statement has been ringing in my head for a few months, something that now brings about 53 million results on google - "AI is eating software". Cool, lets explore a few ideas how we could help that consumption 😋

## Practical basics of a programming language

Whenever I try to pick up a new programming language, I'm first always trying to learn that minimal subset of it - essentially - conditional statements, functions, loops and type system if the language has it. Rest all is required but one can technically go miles with just this set of constructs.

So lets see how AI mixes with these!

We are mostly looking at **runtime** ideas. Code-time I guess there are quite a few and more sophisticated tools out already. But, we all saw grok, inference is getting FAST and dirt cheap, hence runtime AI consultation would be a reality in a few years.

## If conditions

### Zero-shot if conditions

Now that we have models that fare well in 0-shot usecases, we can construct a `zero_shot_if`, lets call it `when`.

We will make use of Natural Language Inference models (NLI for short). These models are trained to figure out if a hypothesis entails from a premise or is there neutrality or contradiction.

So,

"the reflection of the sky on a clear lake was blue in color" entails from "the sky is blue"

"Pythons are very large" is neutral in context of the premise "the sky is blue"

whereas

"The sky is red" is a contradiction in context of the premise "the sky is blue".


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

We launch the api with:

```bash
genius rise
```

This hosts an api which can be called like:

```bash
/usr/bin/curl -X POST localhost:3000/api/v1/entailment \
    -H "Content-Type: application/json" \
    -u "user:password" \
    -d '{
        "premise": "This a very good entry level smartphone, battery last 2-3 days after fully charged when connected to the internet. No memory lag issue when playing simple hidden object games. Performance is beyond my expectation, i bought it with a good bargain, couldnt ask for more!",
        "hypothesis": "the phone has an awesome battery life"
    }' | jq
```

Now lets build the language construct that acts as a soft-if condition and internally calls this api:

```python
import requests


def call_nli(premise, hypothesis):
    data = {"premise": premise, "hypothesis": hypothesis}

    response = requests.post(
        "http://localhost:3000/api/v1/entailment",
        json=data,
        auth=("user", "password"),
    )
    return response.json()


def when(premise, hypothesis, threshold=0.7):
    result = call_nli(premise, hypothesis)
    entailment_score = result["label_scores"]["ENTAILMENT"]

    return True if entailment_score >= threshold else False
```

This can be used as follows:

```python
text = "This a very good entry level smartphone, battery last 2-3 days after fully charged when connected to the internet. No memory lag issue when playing simple hidden object games. Performance is beyond my expectation, i bought it with a good bargain, couldnt ask for more!"

if when(text, "has awesome battery life"):
    print("The phone has an awesome battery life!")
else:
    print("The phone's battery life is bad.")

# The phone has an awesome battery life!
```

Or content filtering:

```python
text = "Goddammit these guys are total idiots. Why have they even made a graphics card so expensive one has to sell their kidneys just to experience raytracing on 8K? I mean come on. We also remember how you treated us Linux users with your shitty drivers crashing Xorg for years before cloud became your fucking cash cow."

if when(text, "has profanity in it"):
    print("Reject the review and send the user a stern email!")
else:
    print("The review is cleared for publication.")

# Reject the review and send the user a stern email!
```

Or policy conformance:

```python
text = "Fuck you nvidia - linus torvalds."

if when(text, "is anti-nvidia"):
    print("Hey! Jensen Huang is God!")
else:
    print("Yes, all praise the Lord. And gaben.")

# Hey! Jensen Huang is God!

text = "dude nvidia rocks"

if when(text, "is anti-nvidia"):
    print("Hey! Jensen Huang is God!")
else:
    print("Yes, all praise the Lord. And gaben.")

# Yes, all praise the Lord. And gaben.
```

A lot of useful stuff could be done with this. Consider this pattern:

`Given document A, find if premise P is true`. This, to my knowledge happens to be a task which is a significant part of a large number of processes:

Check if the document meets certain complex standards
- whether the bank statement is recent enough
- whether the document uploaded is correct
- whether the addresses or other text approximately match
- robotic process automation in finance
- content moderation
- content quality checks
- asking any binary question to a document about itself

The actual usecases of NLI is much broader than this list.

### Zero-shot if conditions on images

In multi-modal things get saucier.

Lets deploy bakllava:

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

and `genius rise`

```python
import requests

def when(image_base64, hypothesis):
    question = "<image>\nUSER: If the below statement is true in relation to the image. \nReturn nothing except one word - 'true' or 'false':\n\n" + hypothesis + "\nASSISTANT:"

    data = {
        "image_base64": image_base64,
        "question": question,
        "do_sample": False,
        "max_new_tokens": 1,
    }

    response = requests.post(
        "http://localhost:3000/api/v1/answer_question",
        json=data,
        auth=("user", "password"),
    )
    data = response.json()
    return "true" in data["answer"].replace(question, "").strip().lower()
```

and can be used as:

```bash
import base64

with open("image.jpg", "rb") as image_file:
    image_base64 = base64.b64encode(image_file.read()).decode("utf-8")

if when(image_base64, "contains a cat on a sofa"):
    print("Heyyy kitty!")
else:
    print("Get on the couch meow!")

# Heyyy kitty!
```

Customary cat image:

![cat](./image.jpg)

## Loops

### AI-powered loop conditions

For loops, it seems rather obvious that its termination condition checking could be done with a model.

Implementing this is rather straightforward:

```python
import requests


def call_nli(premise, hypothesis):
    data = {"premise": premise, "hypothesis": hypothesis}

    response = requests.post(
        "http://localhost:3000/api/v1/entailment",
        json=data,
        auth=("user", "password"),
    )
    return response.json()


def until(fn, condition, threshold=0.7, *args, **kwargs):
    premise = fn(*args, **kwargs)
    result = call_nli(premise, condition)
    entailment_score = result["label_scores"]["ENTAILMENT"]

    while not entailment_score >= threshold:
        premise = fn(*args, **kwargs)
        result = call_nli(premise, condition)
        entailment_score = result["label_scores"]["ENTAILMENT"]
```

This can be used like this:

Keep hitting till it starts returning whatever response we think we want?

```python
until(
    "is a json with 2 fields: status and response",
    lambda x: requests.get("https://ddos-till-submission.com").text,
)
print("done!")
```

This can also be extended to images of course.

## Exception handling

Handle specific exceptions no more! Let AI figure it out?

How about taking this a notch further? Figure out if an exception needs to be reported to the tech team? Also, if possible suggest a fix in case it is a code problem, if it is a data problem, call it out.

Or even in cases of extreme requirements - let the AI figure out how to fix the code and keep trying until the new code works? (sounds cool but things can go very wrong here).

There could be a lot of benefits of doing this, especially for critical applications. E.g. prevent crashing spark jobs by a few bad data points, or service very large transactions which cannot go wrong, etc

Lets first deploy an LLM. Lets use a good code generation model:

```yaml
version: "1"

bolts:
  my_bolt:
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
      model_name: TheBloke/Mistral-7B-Instruct-v0.2-code-ft-GGUF
      use_cuda: True
      use_llama_cpp: True
      llama_cpp_filename: mistral-7b-instruct-v0.2-code-ft.Q4_K_M.gguf
      llama_cpp_n_gpu_layers: 35
      llama_cpp_n_ctx: 32768
      endpoint: "*"
      port: 3000
      cors_domain: "http://localhost:3000"
```

We bring up the API with:

```bash
genius rise
```

Now, time to write the language extention:

```python
import traceback
from typing import List, Dict
import re
import requests
import sys
import inspect

# We use this to call the api
def send_request_to_api(messages: List[Dict[str, str]]) -> str:
    url = "http://localhost:3000/api/v1/chat_llama_cpp"
    headers = {"Content-Type": "application/json"}
    auth = ("user", "password")
    data = {"messages": messages, "temperature": 0.2, "top_p": 0.95, "top_k": 40, "max_tokens": 2048}

    response = requests.post(url, auth=auth, headers=headers, json=data)
    response_data = response.json()

    if response.status_code == 200:
        last_message = response_data["choices"][0]["message"]["content"]
        return last_message
    else:
        raise Exception("nooooooooooooooooooo!!")

#################################################
# Prompts for doing different functions
#################################################

def analyze_exception(error_message: str, traceback_info: List[str]) -> bool:
    prompt = f"Error message: {error_message}\n\nTraceback:\n{''.join(traceback_info)}\n\nAnalyze if this problem is fixable or is it a transient data problem.\n\nIf it is fixable reply yes else reply no.\n\n. Please answer in only yes or no and nothing else."

    messages = [
        {
            "role": "system",
            "content": "You are an AI assistant.",
        },
        {"role": "user", "content": prompt},
    ]

    response = send_request_to_api(messages)

    return "yes" in response.lower()


def generate_fix_suggestion(error_message: str, traceback_info: List[str]) -> str:
    # Get the name of the function that raised the exception
    function_name = traceback_info[-1].split(",")[0].strip().split(" ")[1]

    # Get the parameter names and values of the function that raised the exception
    param_info = ""
    if function_name:
        try:
            frame = inspect.currentframe()
            while frame:
                if frame.f_code.co_name == function_name:
                    break
                frame = frame.f_back

            if frame:
                func = frame.f_globals.get(function_name)
                if func:
                    params = inspect.signature(func).parameters
                    param_values = {name: frame.f_locals.get(name) for name in params}
                    param_info = "\n".join(f"{name}: {value}" for name, value in param_values.items())
        except (KeyError, ValueError):
            pass

    prompt = f"Error message: {error_message}\n\nTraceback:\n{''.join(traceback_info)}\n\nFunction: {function_name}\nParameters:\n{param_info}\n\nSuggest a fix for this code problem."

    messages = [
        {"role": "system", "content": "You are an AI assistant."},
        {"role": "user", "content": prompt}
    ]

    response = send_request_to_api(messages)

    # Extract Python code blocks from the response
    code_blocks = re.findall(r'```python\n(.*?)```', response, re.DOTALL)

    if code_blocks:
        # Return the first code block found
        return code_blocks[0].strip()
    else:
        # Return the entire response if no code blocks are found
        return response


def evaluate_reporting_criteria(error_message: str, traceback_info: List[str]) -> bool:
    prompt = f"Error message: {error_message}\n\nTraceback:\n{''.join(traceback_info)}\n\Is this exception critical enough to be reported to the tech team or is this a one-off issue? (Yes/No)\n\nPlease answer in only yes or no and nothing else."

    messages = [{"role": "system", "content": "You are an AI assistant."}, {"role": "user", "content": prompt}]

    response = send_request_to_api(messages)

    return "yes" in response.lower()

# The final utility
def figure_it_out(e: Exception):
    # Get the exception details
    exc_type, exc_value, exc_traceback = sys.exc_info()
    raise_exception = False

    # Extract the exception message and traceback
    error_message = str(exc_value)
    traceback_info = traceback.format_tb(exc_traceback)
    frame_info = inspect.getframeinfo(exc_traceback.tb_frame)

    # Analyze the exception using AI
    is_fixable = analyze_exception(error_message,  traceback_info)

    if is_fixable:
        # Attempt to suggest a fix or provide insights
        suggested_fix = generate_fix_suggestion(str(exc_value), traceback_info)
        print(f"Suggested fix: {suggested_fix}")
        return suggested_fix
    else:
        raise_exception = True
        print(f"Not fixable, die like in php")

    # Determine if the exception needs to be reported to the tech team
    should_report = evaluate_reporting_criteria(error_message, traceback_info)

    if should_report:
        print("🚨🚨🚨🚨🚨🚨🚨🚨🚨")
        # Placeholder for reporting logic
        # report_exception(error_message, traceback_info)

    if raise_exception:
        raise e
```

This can be used as such:

```python
def try_ai_exception_handler(x):
    try:
        lol = x / 0
        return x / 3
    except Exception as e:
        solution = figure_it_out(e)
        if solution:
            exec(solution)

y = try_ai_exception_handler(10)
print(y)

# Not fixable, die like in php
# 🚨🚨🚨🚨🚨🚨🚨🚨🚨
# ZeroDivisionError: division by zero
```

```python
def try_ai_exception_handler(x):
    try:
        lol = open("file.txt")
    except Exception as e:
        solution = figure_it_out(e)
        if solution:
            exec(solution)

y = try_ai_exception_handler(10)
print(y)

# Suggested fix:
# try:
#     with open('/path/to/file.txt', 'r') as lol:
#         print(lol.read())
# except FileNotFoundError:
#     print("The file does not exist.")

# The file does not exist.
# None
```

Well, maybe stronger LLMs for the self-correction part. But the intimation logic or doing small simple but semi-open ended operations might be possible on machine, before sending to sentry etc.

## Functions

### Adaptive functions

Functions such that, when they fail can rewrite themselves till they pass, or can adapt themselves to the data so they never fail.

```python
import traceback
from typing import List, Dict
import re
import requests
import sys
import inspect

# We use this to call the api
def send_request_to_api(messages: List[Dict[str, str]]) -> str:
    url = "http://localhost:3000/api/v1/chat_llama_cpp"
    headers = {"Content-Type": "application/json"}
    auth = ("user", "password")
    data = {"messages": messages, "temperature": 0.2, "top_p": 0.95, "top_k": 40, "max_tokens": 2048}

    response = requests.post(url, auth=auth, headers=headers, json=data)
    response_data = response.json()

    if response.status_code == 200:
        last_message = response_data["choices"][0]["message"]["content"]
        return last_message
    else:
        raise Exception("nooooooooooooooooooo!!")

def generate_fix_suggestion(function: str, traceback_info: List[str]) -> str:
    # Get the name of the function that raised the exception
    function_name = traceback_info[-1].split(",")[0].strip().split(" ")[1]

    # Get the parameter names and values of the function that raised the exception
    param_info = ""
    if function_name:
        try:
            frame = inspect.currentframe()
            while frame:
                if frame.f_code.co_name == function_name:
                    break
                frame = frame.f_back

            if frame:
                func = frame.f_globals.get(function_name)
                if func:
                    params = inspect.signature(func).parameters
                    param_values = {name: frame.f_locals.get(name) for name in params}
                    param_info = "\n".join(f"{name}: {value}" for name, value in param_values.items())
        except (KeyError, ValueError):
            pass

    prompt = f"Function code: {function}\n\nTraceback:\n{''.join(traceback_info)}\n\nFunction: {function_name}\nParameters:\n{param_info}\n\nRewrite the complete function with a fix."

    messages = [
        {"role": "system", "content": "You are an AI assistant that fixes code."},
        {"role": "user", "content": prompt}
    ]

    response = send_request_to_api(messages)

    # Extract Python code blocks from the response
    code_blocks = re.findall(r'```python\n(.*?)```', response, re.DOTALL)

    if code_blocks:
        # Return the first code block found
        return code_blocks[0].strip()
    else:
        # Return the entire response if no code blocks are found
        return response

def adapt_to_data(fn, *args, **kwargs):
    try:
        return fn(*args, **kwargs)
    except Exception as e:
        exc_type, exc_value, exc_traceback = sys.exc_info()
        traceback_info = traceback.format_tb(exc_traceback)
        solution = generate_fix_suggestion(inspect.getsource(fn), traceback_info)
        print("------------------------------------------------")
        print(solution)
        print("------------------------------------------------")
        if solution:
            try:
                exec(solution)
            except:
                raise e
        else:
            raise e
```

Example: functions that expect a certain field without checking if they exist first:

```python
data = {
    "field1": 3,
    "field2": ["lol"]
}

def handler(data):
    field1 = data["field1"]
    field2 = data["field2"]
    field3 = data["field3"]

    return field2

adapt_to_data(handler, data)

# ------------------------------------------------
# def handler(data):
#     if "field1" in data:
#         field1 = data["field1"]
#     else:
#         field1 = None

#     if "field2" in data:
#         field2 = data["field2"]
#     else:
#         field2 = None

#     if "field3" in data:
#         field3 = data["field3"]
#     else:
#         field3 = None

#     return field2
# ------------------------------------------------
```

### Auto-generated mapping functions / soft-composition

A lot of integrations code is going to be written by AI. Now, the core of any integration is a mapping and no matter how much automation you do, one finally ends up with this core problem, that each api - api mapping has to be done by hand. And then hire integration engineers etc etc. This kind of thing happens to be an entire enterprise play and different shitty ERPs talking to each other via shitty code is a huge mess. Lets make it worse with AI? 😊

**"soft"-composing functions**

Say function `f1` has output signature `o1` and function `f2` has input signature `i2`, if `i2` is a subset of `o1`, then we should be able to do `f2(f1(x))` through this method. However, as we will see, if `o2` can be derievd from `o1` that should also work.

**Implementation**

Cool go given two api schema:

1. Generate a mapping
2. Test each mapping against mock inputs
3. Generate 10 total working mappings
4. Ask the human for feedback
5. The preferred mapping is deployed as config to an abstract integration core system

```python
import traceback
from typing import List, Dict
import re
import requests
import sys
import inspect

# We use this to call the api
def send_request_to_api(messages: List[Dict[str, str]]) -> str:
    url = "http://localhost:3000/api/v1/chat_llama_cpp"
    headers = {"Content-Type": "application/json"}
    auth = ("user", "password")
    # note: greater temperature to get diverse outputs
    data = {"messages": messages, "temperature": 0.7, "top_p": 0.95, "top_k": 40, "max_tokens": 2048}

    response = requests.post(url, auth=auth, headers=headers, json=data)
    response_data = response.json()

    if response.status_code == 200:
        last_message = response_data["choices"][0]["message"]["content"]
        return last_message
    else:
        raise Exception("nooooooooooooooooooo!!")

def generate_mapping_function(input_example, output_example):
    # Prepare the prompt for the LLM
    prompt = f"""
Given the input schema:
{input_example}

And the desired output schema:
{output_example}

Generate a Python function that takes an input matching the input schema and returns an output matching the output schema. The function should be named 'mapping_function'.
"""

    # Call the LLM API to generate the mapping function
    messages = [
        {"role": "system", "content": "You are an AI assistant that generates Python code."},
        {"role": "user", "content": prompt}
    ]
    response = send_request_to_api(messages)

    # Extract the generated function code from the response
    function_code = re.findall(r'```python\n(.*?)```', response, re.DOTALL)

    if function_code:
        # Execute the generated function code
        exec(function_code[0], globals())

        # Test the generated mapping function with the example input
        try:
            mapped_output = mapping_function(input_example)
            print("Generated mapping function:")
            print(function_code[0])
            print("\nTesting the mapping function:")
            print(f"Input: {input_example}")
            print(f"Output: {mapped_output}")

            # Validate the mapped output against the desired output schema
            if list(mapped_output.keys()) == list(output_example.keys()):
                print("Mapping function generated successfully!")
                return function_code[0]
            else:
                print("Mapped output does not match the desired output schema.")
                raise Exception("Function generated is incorrect")
        except Exception as e:
            print(f"Error occurred while testing the mapping function: {e}")
            raise e
    else:
        print("No mapping function code found in the LLM response.")
        return None

```

Lets use this:

```python
input_example = {
    "first name": "string",
    "last name": "string",
    "age": "integer"
}

output_example = {
    "status": "success",
    "data": {
        "first name": "string",
        "last name": "string",
        "full name": "string",
        "age": "integer"
    }
}

generated = []
while len(generated) < 3:
    try:
        fn = generate_mapping_function(input_example, output_example)
        generated.append(fn)
    except:
        pass

print("Please choose which one you think is the best:")
for gen in generated:
    print("------------------------------------------------")
    print(gen)
    print("------------------------------------------------")
```

This is what the output looks like:

```python
Please choose which one you think is the best:
------------------------------------------------
def mapping_function(input_data):
    if isinstance(input_data, dict) and set(input_data.keys()) == {'first name', 'last name', 'age'}:
        first_name = input_data['first name']
        last_name = input_data['last name']
        age = input_data['age']
        full_name = first_name + ' ' + last_name
        output_data = {'status': 'success', 'data': {'first name': first_name, 'last name': last_name, 'full name': full_name, 'age': age}}
        return output_data
    else:
        return None

------------------------------------------------
------------------------------------------------
def mapping_function(input_dict):
    if not all(k in input_dict for k in ('first name', 'last name', 'age')):
        return {'status': 'failure', 'error': 'Input dictionary is missing one or more required fields.'}

    first_name = input_dict['first name']
    last_name = input_dict['last name']
    age = input_dict['age']
    full_name = f"{first_name} {last_name}"

    return {'status': 'success', 'data': {'first name': first_name, 'last name': last_name, 'full name': full_name, 'age': age}}

------------------------------------------------
------------------------------------------------
def mapping_function(input_data):
    if not all(k in input_data for k in ('first name', 'last name', 'age')):
        return {'status': 'failure', 'error': 'Missing required fields'}

    full_name = input_data['first name'] + ' ' + input_data['last name']
    output_data = {
        'status': 'success',
        'data': {
            'first name': input_data['first name'],
            'last name': input_data['last name'],
            'full name': full_name,
            'age': input_data['age']
        }
    }
    return output_data

------------------------------------------------
```

This was, of course, a toy example. If the testing is strong enough, and the rest of the stack where this plugs into generic enough, then even te human can be removed from the loop.
Now think of all those multi-vendor API integrations like payment gateways that can now be automated without killing oneself!

## Conclusion

Thankfully, this conclusion is not written by AI lol. Hope you had fun!
