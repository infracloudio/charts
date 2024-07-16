# text-embeddings-interface

A helm chart to deploy the [Text Embeddings Inference(TEI)](https://github.com/huggingface/text-embeddings-inference) from Hugging Face.

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `tei`:

```bash
helm install tei infracloud-charts/text-embeddings-inference
```

## Uninstalling the Chart

To uninstall the `tei` deployment:

```bash
helm uninstall tei
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
