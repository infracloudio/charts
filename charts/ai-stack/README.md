# ai-stack

This chart deploys the AI stack on a Kubernetes cluster using the Helm package manager.

![AI-Stack](https://github.com/user-attachments/assets/797bc164-983a-49e1-a4ce-1a959a62ddd5)


## Components

The AI stack consists of the following components:

- [Text Embeddings Inference(TEI)](../text-embeddings-inference/)
- [Text Generation Inference(TGI)](../text-generation-inference/)
- [Grafana Dashboards](../infracloud-dashboards)
- [ChromaDB](../chromadb)
- [vLLM](../vllm)

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

Create a secret with HuggingFace token:

```bash
kubectl create secret generic hf-api-token --from-literal HF_API_TOKEN=<your-huggingface-token>
```

To install the chart with the release name `ai-stack`:

```bash
helm install ai-stack infracloud-charts/ai-stack
```

## Uninstalling the Chart

To uninstall the `ai-stack` deployment:

```bash
helm uninstall ai-stack
```
