# Kueue (Red Hat build of Kueue via OLM)

Module 3 prerequisite: the kueue.x-k8s.io CRDs, the operator, and a demo quota
tree (research-department Cohort + research-team ClusterQueue). LocalQueues are
created per-user in the exercise.

## KNOWN ISSUE — webhook service selector collision (sjzfp 2026-11-11)

The operator renders `kueue-webhook-service` with the bare kubebuilder-default
selector `control-plane: controller-manager` and **re-renders it continuously**
(the service is owned by the `Kueue/cluster` CR; `unsupportedConfigOverrides`
does not affect it). Any other kubebuilder operator co-located in
`openshift-operators` that carries the same default pod label also matches —
on the sjzfp sandbox the RHCL (kuadrant) and limitador operators (installed by
the maas-platform app, AllNamespaces-only bundles, same for kueue) collide, so
~50% of kueue webhook calls (LocalQueue/ClusterQueue create: conversion,
defaulting, validating) land on pods that do not serve the kueue webhook:

    Error from server: error when creating "STDIN": conversion webhook for
    kueue.x-k8s.io/v1beta1, Kind=LocalQueue failed: Post
    "https://kueue-webhook-service.openshift-operators.svc:443/convert?timeout=30s":
    dial tcp <pod-ip>:9443: connect: connection refused

Repairs that DO NOT work (all tried on sjzfp):

- patch the Service selector — the kueue operator re-renders it
- `unsupportedConfigOverrides` on the Kueue CR — non-functional for the service
- move any of the operators to their own namespace — all bundles are
  AllNamespaces-only, and only one AllNamespaces OperatorGroup may exist
- relabel the colliding pods — their Deployments' (immutable) selectors
  include the label

Current mitigation:

- the subscription rides `stable-v1.5` (newest channel; may carry a scoped
  selector fix upstream)
- the e2e's LocalQueue task retries (qa-automation/e2e.yml M3), and students
  hitting the error simply re-run the apply

Durable fix is upstream: the webhook service should select `app: kueue` (which
the kueue-controller-manager pods already carry and the colliding pods do not).
If the collision returns after a RHCL upgrade re-renders its operator labels,
verify with:

    oc get endpointslices -n openshift-operators \
      -o json | jq -r '.items[] | select(.metadata.labels."kubernetes.io/service-name"=="kueue-webhook-service") | .endpoints[].targetRef.name'
