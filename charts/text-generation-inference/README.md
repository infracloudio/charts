# text-generation-inference

A helm chart to deploy the [Text Generation Inference(TGI)](https://github.com/huggingface/text-generation-inference) from Hugging Face.

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `tgi`:

```bash
helm install tgi infracloud-charts/text-generation-inference
```

## Uninstalling the Chart

To uninstall the `tgi` deployment:

```bash
helm uninstall tgi
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
