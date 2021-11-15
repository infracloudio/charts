# charts [![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/infracloudio)](https://artifacthub.io/packages/search?repo=infracloudio)
A repo for all Helm charts from InfraCloud

## Steps for adding new helm chart

Once you have a helm chart ready, follow the steps to add it in the chart repo

- Validate helm chart

  ```bash
  $ helm lint example/alpine/
  ```
  Fix helm lint issues if there are any.

- Package the helm chart

  ```bash
  $ helm package examples/alpine
  ```

- Create a branch on top of `gh-pages`

- Add helm chart package to `infracloudio/charts`

- Build the index

  ```bash
  $ helm repo index --url https://infracloudio.github.io/charts --merge index.yaml .
  ```

- Commit, push and raise a PR against `gh-pages`
