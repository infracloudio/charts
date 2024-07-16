# ai-stack

This chart deploys the AI stack on a Kubernetes cluster using the Helm package manager.

## Components

The AI stack consists of the following components:

- Text Embeddings Inference(TEI)
- Text Generation Inference(TGI)

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `ai-stack`:

```bash
helm install ai-stack infracloud-charts/ai-stack
```

## Uninstalling the Chart

To uninstall the `ai-stack` deployment:

```bash
helm uninstall ai-stack
```
