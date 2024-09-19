# vllm

A helm chart to deploy LLM models with [vLLM](https://github.com/vllm-project/vllm)

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `vllm`:

```bash
helm install vllm infracloud-charts/vllm
```

## Uninstalling the Chart

To uninstall the `vllm` deployment:

```bash
helm uninstall vllm
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
