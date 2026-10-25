# GitOps Automation

Automation for the **RHOAI 3.5 Operations Workshop** (this repo). Two layers:

1. **Showroom layer** (`showroom-deployer/`) — deploys the workshop showroom via the
   [zt-showroom-deployer](https://eformat.github.io/helm-charts) Helm chart.
   Values files: `showroom-deployer/values-rhoai-operations{,-fde2}.yaml`.
   Targets: `make template|deploy|status` from the repo root (see below).

2. **Cluster layer** (`cluster/`) — GitOps app-of-apps for the workshop's
   platform + infra:

   - **RHOAI install** (`cluster/rhoai-install/`) — the operator
     (stable-3.5), DSCInitialization and DataScienceCluster, Git-owned
     ("operators as code" + "custom resources as code"). The MaaS
     `aigateway.modelsAsAService` component is deliberately NOT in the Git DSC:
     the maas-platform app enables it once the gateway is up.
   - **MaaS platform** (`cluster/maas-platform/`) — RHCL (Kuadrant) +
     cert-manager operators, the `maas-default-gateway`, the MaaS PostgreSQL,
     the serving-path (LWS/JobSet) + observability operators, user workload
     monitoring, the MaaS telemetry, and the DSC/dashboard MaaS enablement.
     A Helm chart: the Route host and gateway status patch need the cluster
     apps domain (`deployer.domain`, set at the one-time bootstrap apply).
   - **Infra** (`cluster/infra/`) — an in-cluster LDAP directory (FreeIPA,
     FEDORACAPITAL.IO) federated into the EXISTING Keycloak (rhbk), so persona
     users + groups arrive in OpenShift via the OAuth groups claim.

   See [`cluster/START_HERE.md`](cluster/START_HERE.md)
   for the bootstrap steps and verification.

## Showroom layer usage

From the repo root:

```bash
make repo       # add the published chart repo
make template   # render locally (no cluster needed)
make deploy     # deploy to a cluster
make status     # check status
make uninstall  # remove
```

Local chart development:

```bash
make template CHART=~/git/zt-showroom-deployer
make deploy CHART=~/git/zt-showroom-deployer
```

The per-cluster values files (`values-rhoai-operations-fde2.yaml`, …) carry
lab-scoped credentials and are gitignored — see the values file header.

## Cluster layer bootstrap (one-time)

```bash
KUBECONFIG=~/.kube/config.fde2 oc apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: bootstrap-ops
  namespace: openshift-gitops
spec:
  project: default
  source:
    repoURL: https://github.com/rhpds/ph-operations-rhoai
    targetRevision: main
    path: automation/gitops/cluster/infra/bootstrap
    helm:
      values: |
        deployer:
          domain: apps.cluster-jt286.dyn.redhatworkshops.io
          apiUrl: https://api.cluster-jt286.dyn.redhatworkshops.io:6443
        freeipa:
          password: <reuse the existing lab admin password>
          ingressDomain: apps.cluster-jt286.dyn.redhatworkshops.io
        opsLdap:
          password: <same>
          keycloakIngressHostname: sso.apps.cluster-jt286.dyn.redhatworkshops.io
  destination:
    server: https://kubernetes.default.svc
    namespace: openshift-gitops
  syncPolicy:
    automated:
      prune: false
      selfHeal: true
    syncOptions:
      - RespectIgnoreDifferences=true
    retry:
      limit: 10
      backoff:
        duration: 5s
        factor: 2
        maxDuration: 3m
EOF
```

See [`cluster/START_HERE.md`](cluster/START_HERE.md) for the full flow.

## Standing rules

- Mike is git master — make file edits and stop; he reviews/commits/pushes.
- No credentials in any committable file. Passwords ride on-cluster values
  (one-time bootstrap apply); ArgoCD repo secrets are out-of-band.
- Kubeconfig: only `~/.kube/config.fde2` for the fde2 cluster.
