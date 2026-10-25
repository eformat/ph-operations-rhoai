# RHOAI 3.5 Operations Workshop

## Overview

This hands-on, day-2 operations lab guides platform administrators and MLOps engineers through operating Red Hat OpenShift AI (RHOAI) 3.5 at scale in production-representative conditions. It is designed as a follow-up to the RHOAI Deploy & Configure workshop and starts from a pre-provisioned RHOAI 3.5 cluster: the platform, the MaaS stack, the identity providers, and the per-module workloads are deployed by GitOps before students start.

Participants learn the "phoenix" platform-as-code pattern with GitOps and ACM, model a data-stewardship organization onto OpenShift RBAC and the RHOAI Auth CR, manage models and assets at scale (workbench images, ModelCars, model registry, Kueue), walk through the RHOAI upgrade lifecycle with OLM channels and operator pinning, observe the platform with monitoring, metrics export, and audit logs, and protect RHOAI with OADP-based backup and disaster recovery. The workshop teaches patterns and practices rather than prescriptions — the goal is to teach operators how to "start well" on day-2 operations.

## Target Audience

- **Role:** Platform administrators and MLOps engineers who have already deployed RHOAI 3.5 and need to operate it at scale
- **Experience level:** Advanced
- **What they already know:** OpenShift administration (projects, operators, routes, CLI), RHOAI concepts (workbenches, model serving, pipelines), and basic Git/YAML/bash fluency
- **What they don't know:** Day-2 operations patterns for RHOAI — GitOps/ACM platform management, data-stewardship RBAC models, asset lifecycle at scale, upgrade planning, observability, and backup/DR

## Prerequisites

- Completed the RHOAI Deploy & Configure workshop (provides the running, pre-provisioned cluster environment)
- Basic OpenShift administration experience (projects, operators, routes, CLI)
- Familiarity with RHOAI concepts (workbenches, model serving, pipelines)
- Lab prerequisites cannot be validated automatically; participants are expected to meet them before starting

## Learning Objectives

1. Describe the phoenix platform-as-code pattern and manage RHOAI with GitOps, app-of-apps, and ACM policy generation
2. Model a data-stewardship organization onto OpenShift groups, Data Science Projects, RoleBindings, and the RHOAI Auth CR
3. Configure MaaS permission tiers bound to groups and verify RBAC decisions as different personas
4. Build custom workbench images, ModelCar OCI containers, and register models in the model registry at scale
5. Plan RHOAI operator upgrades with OLM channels, dependent operator pinning, and pre-upgrade checklists
6. Observe the platform with RHOAI monitoring dashboards, PromQL metrics export, audit logs, and llm-d Perses dashboards
7. Protect RHOAI with OADP backups, namespace restore, and an understanding of the CRD dependency graph

## Content Type

Lab (hands-on)

## Products & Technologies

- Red Hat OpenShift Container Platform (OCP) 4.21+
- Red Hat OpenShift AI (RHOAI) 3.5
- OpenShift GitOps (ArgoCD), app-of-apps pattern
- Advanced Cluster Management (ACM) + PolicyGenerator
- Advanced Cluster Security (ACS)
- FreeIPA (in-cluster LDAP) + OCP-native LDAP IdP + Keycloak (rhbk)
- Models-as-a-Service (MaaS): MaaSSubscription, MaaSAuthPolicy, MaaSModelRef
- Red Hat Connectivity Link (RHCL) / Kuadrant, Authorino, Limitador
- OpenShift Builds, ImageStreams, ModelCar OCI images, KServe
- Model Registry (REST API, Postgres)
- Red Hat build of Kueue, NVIDIA MIG/GPU Operator, DRA, llm-d (conceptual)
- OLM (Subscription/CSV/InstallPlan/PackageManifest)
- RHOAI monitoring stack (Prometheus, Thanos querier, Alertmanager, Perses)
- OpenShift Logging, audit logs, Prometheus remote-write
- OADP (Velero, kopia), NooBaa (MCG) / OpenShift Data Foundation
- HashiCorp Vault, Age/SOPS, External Secrets Operator (concepts)
- Qwen2.5-0.5B-Instruct (pre-published Lending modelcar via MaaS)

## Module Map

| Module | Title | Duration |
|--------|-------|----------|
| 1 | Operations Guidelines and Patterns | 30 min |
| 2 | Data Stewardship, Users & Access Control | 60 min |
| 3 | Managing Models and Assets at Scale | 60 min |
| 4 | Upgrades | 45 min |
| 5 | Observe & Debug | 40 min |
| 6 | Backups & Disaster Recovery | 45 min |
| — | Getting Connected (setup) | 10 min |
| — | Appendix: Disconnected Considerations (reserved) | — |
| — | Conclusion | 10 min |
| — | **Total lab** | **~5 hours** |

## Difficulty Level

Advanced

## Environment

**Learner view:** Participants start with a pre-provisioned RHOAI 3.5 cluster: the GitOps cluster layer (app-of-apps) has deployed RHOAI (operator + DSC/DSCI), the MaaS platform stack (Kuadrant gateway, PostgreSQL, observability), the FreeIPA/LDAP identity stack with pre-created persona users and groups, the pre-published Lending modelcar (via MaaS), the model registry, Kueue with a demo quota tree, and the OADP operator. Students clone the workshop manifests repository (GitHub) during Getting Connected and apply exercise manifests by hand throughout. GPU topics are covered conceptually — the lab cluster is CPU-only.

**Automation needed:** Yes — a two-layer GitOps automation (this repository's `automation/gitops/cluster/`) provisions the platform and infra before the workshop: RHOAI install, MaaS platform, FreeIPA/LDAP identity, per-module workloads (maas-model, mlflow, model-registry, kueue, oadp). The zt-showroom-deployer chart deploys the workshop showroom UI.

## Infrastructure Requirements

- **Cloud provider:** TBD — confirmed in infrastructure phase
- **Cluster type:** Multinode
- **OCP version:** 4.21
- **Topology:** Shared cluster (several exercises run read-only or reference-only because the cluster is shared)
- **Sizing:** TBD — confirmed in infrastructure phase (pre-provisioned lab cluster)
- **Automation approach:** GitOps (app-of-apps bootstrap; no per-student Ansible)
- **AI/MaaS:** MaaS + pre-published open-source model (`qwen25-05b` Lending modelcar); no GPU required
- **External services:** `github.com`, `quay.io`, `registry.redhat.io`
- **AAP version:** N/A
- **Non-GA products:** AITenant (Tech Preview), MaaS external metering (Dev Preview, planned for 3.6) — covered conceptually; no special access required

## Assessment Strategy (Optional)

No automated assessment. Participants verify their own progress by observing CLI output, resource status conditions, and dashboard state at the end of each exercise. Each exercise ends with a Verify step (e.g., persona `oc auth can-i` results, MaaSModelRef Ready, backup phase Completed, restored ConfigMap present) that confirms correct completion.
