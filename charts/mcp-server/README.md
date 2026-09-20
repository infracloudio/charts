# mcp-server

One MCP server that speaks streamable HTTP, as the AIOps platform deploys it from its catalog.
The platform's backend renders the values; the chart is not specific to one server.

- The pod is hardened for an image that somebody else wrote:
  no service-account token, non-root (65532), no privilege escalation, no capabilities, a read-only root file system with an `emptyDir` on `/tmp`.
- The Service is `ClusterIP`, and a NetworkPolicy admits only the pods named in `networkPolicy.ingressFrom` (the platform's LiteLLM proxy).
  Both values are required: the chart fails without them rather than install a server that every pod can call.
- `networkPolicy.egress` is `none`, `public` (port 443 outside the private ranges) or `cluster` (also the private ranges).
  No mode opens the link-local range, so the cloud metadata address stays closed.
- `image.tag` is a tag or a digest (`@sha256:...`); `latest` is refused.
- `settingsChecksum` restarts the pod when only a secret setting changed.

```bash
helm install mcpi-1234abcd charts/mcp-server \
  --set fullnameOverride=mcpi-1234abcd \
  --set image.repository=mcp/grafana --set image.tag=<tag> \
  --set-json 'args=["-t","streamable-http","-address","0.0.0.0:8000","-allowed-hosts","mcpi-1234abcd.ai-stack.svc,mcpi-1234abcd.ai-stack.svc:8000"]' \
  --set networkPolicy.ingressFrom.namespace=litellm \
  --set 'networkPolicy.ingressFrom.podLabels.app\.kubernetes\.io/name=litellm' \
  --set networkPolicy.egress=cluster
```
