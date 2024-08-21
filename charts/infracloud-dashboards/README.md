# infracloud-dashboards

A helm chart to deploy the [InfraCloud Dashboards](https://github.com/infracloudio/charts/tree/main/charts/infracloud-dashboards/grafana-dashboards) from InfraCloud. We have forked few original dashboards from community and added few customizations to make it work with our setup.

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
