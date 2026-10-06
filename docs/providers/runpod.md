# RunPod

Phase 3.

## Pods

- gateway runs as a small **CPU pod**; TLS comes from RunPod's proxy URL, so no domain needed
- GPU pods (secure cloud by default; community cloud is opt-in with a warning) run the engine images directly
- spot pods for `capacity: spot`

## Serverless

`capacity: serverless` is the one exception to the tunnel model:

- the gateway proxies to RunPod's load-balancing endpoint with a shared secret
- RunPod scales the workers; the gateway sets worker min/max and sets max=0 when the budget cap trips
- the agent runs in "direct" mode inside the worker container
