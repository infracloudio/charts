# ollama

A Helm chart for serving small models on CPU or GPU with [Ollama](https://ollama.com).

The platform backend renders the values below from `backend/templates/ollama-llm-values.yaml.jinja`;
install this chart directly only for local testing.

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `ollama`:

```bash
helm install ollama infracloud-charts/ollama
```

To pull one or more model tags on start,
set `models.pull` to a list of Ollama tags:

```bash
helm install ollama infracloud-charts/ollama --set 'models.pull={qwen3:0.6b,smollm2:1.7b}'
```

The pod runs a `postStart` hook that waits for the server to answer,
then pulls every tag in `models.pull`;
the readiness probe only succeeds once the hook returns,
so the pod is Ready only after every requested model is on disk.

## Uninstalling the Chart

To uninstall the `ollama` deployment:

```bash
helm uninstall ollama
```

The command removes all the Kubernetes components associated with the chart and deletes the release,
including the PersistentVolumeClaim holding pulled models,
so a reinstall pulls every tag again.
To keep pulled models across reinstalls, point `persistence.existingClaim` at a PVC
that outlives the release.

## Values

| Key | Type | Default | Description |
| --- | --- | --- | --- |
| replicaCount | int | `1` | Number of pod replicas; keep at 1, models are pulled onto a single ReadWriteOnce volume |
| image.repository | string | `"ollama/ollama"` | Container image repository |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.tag | string | `""` | Image tag; defaults to the chart `appVersion` |
| imagePullSecrets | list | `[]` | Image pull secrets |
| nameOverride | string | `""` | Override the chart name used in generated resource names |
| fullnameOverride | string | `""` | Override the fully qualified app name |
| serviceAccount.create | bool | `true` | Create a ServiceAccount |
| serviceAccount.automount | bool | `true` | Automount the ServiceAccount token |
| serviceAccount.annotations | object | `{}` | Annotations for the ServiceAccount |
| serviceAccount.name | string | `""` | ServiceAccount name; defaults to the fullname template |
| podAnnotations | object | `{}` | Annotations added to the pod |
| podLabels | object | `{}` | Labels added to the pod |
| podSecurityContext | object | `{}` | Pod-level securityContext |
| securityContext | object | `{}` | Container-level securityContext |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| service.port | int | `80` | Service port; the container always listens on `11434` |
| ollama.host | string | `"0.0.0.0:11434"` | `OLLAMA_HOST` inside the pod |
| ollama.keepAlive | string | `"1h"` | How long a loaded model stays in memory after the last request (`OLLAMA_KEEP_ALIVE`) |
| ollama.contextLength | int | `4096` | Default context window (`OLLAMA_CONTEXT_LENGTH`); small models on CPU do not need more |
| models.pull | list | `[]` | Tags pulled by a postStart hook once the server answers; the pod is Ready only after every tag is on disk |
| env | list | `[]` | Extra environment variables, in container `env` entry form |
| resources.requests.cpu | string | `"1"` | CPU request |
| resources.requests.memory | string | `"2Gi"` | Memory request |
| resources.limits.memory | string | `"4Gi"` | Memory limit |
| persistence.enabled | bool | `true` | Create a PersistentVolumeClaim for `/root/.ollama`; when `false` the model directory is an `emptyDir` |
| persistence.storageClass | string | `""` | StorageClass for the created PVC; empty uses the cluster default |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes for the created PVC |
| persistence.size | string | `"10Gi"` | Size of the created PVC |
| persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one; when set, no PVC is created by this chart |
| livenessProbe | object | see `values.yaml` | Liveness probe, `GET /api/version` on the `http` port |
| readinessProbe | object | see `values.yaml` | Readiness probe, `GET /api/version` on the `http` port |
| nodeSelector | object | `{}` | Node selector |
| tolerations | list | `[]` | Tolerations |
| affinity | object | `{}` | Affinity rules |
