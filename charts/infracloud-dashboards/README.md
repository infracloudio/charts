# infracloud-dashboards

A Helm chart that deploys the Grafana dashboards this project uses: TGI, TEI, vLLM, NVIDIA DCGM and LiteLLM.
The community dashboards are forked and adapted for the labels these charts emit;
the LiteLLM dashboard is written for this project.

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `infracloud-dashboards`:

```bash
helm install infracloud-dashboards infracloud-charts/infracloud-dashboards
```

## Uninstalling the Chart

To uninstall the `infracloud-dashboards` deployment:

```bash
helm uninstall infracloud-dashboards
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
