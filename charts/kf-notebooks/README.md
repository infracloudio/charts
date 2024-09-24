# KF-Notebooks

A helm chart to deploy the [Kubeflow Notebooks](https://www.kubeflow.org/docs/components/notebooks/) on a Kubernetes cluster.

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `kf-notebooks`:

```bash
helm install kf-notebooks infracloud-charts/kf-notebooks
```

## Uninstalling the Chart

To uninstall the `kf-notebooks` deployment:

```bash
helm uninstall kf-notebooks
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the KF-Notebooks chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `global.storageClassName` | Global storage class name | `""` |
| `nameOverride` | String to partially override kf-notebooks.fullname template | `""` |
| `fullnameOverride` | String to fully override kf-notebooks.fullname template | `""` |
| `service.enabled` | Enable service creation | `true` |
| `service.port` | Service port | `80` |
| `service.type` | Service type | `ClusterIP` |
| `notebooks.pytorch.enabled` | Enable PyTorch notebook | `false` |
| `notebooks.pytorch.name` | PyTorch notebook name | `jupyter-pytorch-cuda` |
| `notebooks.pytorch.image.repository` | PyTorch notebook image repository | `kubeflownotebookswg/jupyter-pytorch-cuda-full` |
| `notebooks.pytorch.image.tag` | PyTorch notebook image tag | `v1.9.0` |
| `notebooks.pytorch.image.pullPolicy` | PyTorch notebook image pull policy | `IfNotPresent` |
| `notebooks.pytorch.resources` | PyTorch notebook resources | See `values.yaml` for defaults |
| `notebooks.pytorch.storage.size` | PyTorch notebook storage size | `5Gi` |
| `notebooks.vscode.enabled` | Enable VSCode notebook | `false` |
| `notebooks.vscode.name` | VSCode notebook name | `codeserver-python` |
| `notebooks.vscode.image.repository` | VSCode notebook image repository | `kubeflownotebookswg/codeserver-python` |
| `notebooks.vscode.image.tag` | VSCode notebook image tag | `v1.9.0` |
| `notebooks.vscode.image.pullPolicy` | VSCode notebook image pull policy | `IfNotPresent` |
| `notebooks.vscode.resources` | VSCode notebook resources | See `values.yaml` for defaults |
| `notebooks.vscode.storage.size` | VSCode notebook storage size | `5Gi` |


Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
