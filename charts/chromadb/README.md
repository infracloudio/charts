# chromadb

A helm chart to deploy the [ChromaDB](https://github.com/chroma-core/chroma) vector database from Chroma.

## Setup Helm Repository

```bash
helm repo add infracloud-charts https://infracloudio.github.io/charts
helm repo update
```

See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation.

## Installing the Chart

To install the chart with the release name `chromadb`:

```bash
helm install chromadb infracloud-charts/chromadb
```

## Uninstalling the Chart

To uninstall the `chromadb` deployment:

```bash
helm uninstall chromadb
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
