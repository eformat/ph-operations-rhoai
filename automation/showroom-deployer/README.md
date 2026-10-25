# Showroom Deployer Values

Helm values for deploying the **workshop showroom UI** via the
[zt-showroom-deployer](https://eformat.github.io/helm-charts) chart. Deploy
from the repo root with `make template|deploy|status|uninstall` (or `helm
upgrade --install` directly, see the root Makefile).

## Files

- `values-rhoai-operations.yaml` — the **template** (placeholder credentials,
  example.com defaults). The only values file in git.
- `values-rhoai-operations-fde2.yaml`, `values-rhoai-operations-fde.yaml` —
  **per-cluster** values (real cluster coordinates, guid, wetty ssh host/pass).
  Carried lab-scoped credentials — gitignored by design, never commit them.

The `showroom.gitRepoUrl` points at this repo — the showroom content container
builds the Antora site from it. After the repo moves, update the per-cluster
values (or pass `--set showroom.gitRepoUrl=...`) to the new URL.

## Redeploy example (fde2 / cluster-jt286)

```bash
export KUBECONFIG=~/.kube/config.fde2
helm upgrade --install showroom ~/git/zt-showroom-deployer \
  -n showroom-rhoai-operations --create-namespace \
  -f automation/showroom-deployer/values-rhoai-operations-fde2.yaml \
  --set showroom.gitRepoUrl="https://github.com/rhpds/ph-operations-rhoai.git"
```
