# aiops-platform

The umbrella chart that installs the AIOps control plane:
the backend API, the UI, the gateway objects,
and Postgres, Keycloak and LiteLLM as switchable dependencies.
It can also serve the AI Factory Explorer (`viz.enabled`).

Read `docs/install.md` in the repository root for prerequisites, the values contract,
install, upgrade, backup and how to make a dependency external.
`test/values-external.yaml` shows every dependency switched off,
`test/values-kind.yaml` the local kind install (`make chart-install`).
