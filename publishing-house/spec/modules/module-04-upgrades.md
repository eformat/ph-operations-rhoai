# Module 04 — Upgrades

### Brief Overview

Module 4 is a walkthrough-style module (no actual upgrade is executed): participants inspect the RHOAI release cadence and support policy, examine the OLM subscription anatomy (CSV, InstallPlan, channels), audit all operator subscriptions for pinned-vs-floating channels and Automatic-vs-Manual approval risk, and learn the rhods-operator meta-operator model (DSC-owned components vs external prerequisite operators). Conceptual sections cover the minor-version upgrade workflow, MaaS version differences across RHOAI 3.4/3.5/3.6, and a pre-upgrade checklist with rollback considerations.

### Audience and Time

- **Target personas:** OCP platform administrators, MLOps engineers
- **Prerequisites for this module:** Modules 1–3 completed; RHOAI 3.5 running on the lab cluster
- **Estimated duration:** 45 minutes

### Learning Objectives

- Describe the RHOAI release cadence and life cycle support policy
- Inspect operator subscriptions, installed versions, and available update channels using OLM
- Describe the rhods-operator meta-operator model — the ODH managed components it owns versus the external prerequisite operators it depends on, and the upstream to midstream to product flow
- Explain the differences between manual and automatic approval strategies
- Demonstrate operator pinning to prevent unintended dependent operator upgrades
- Describe MaaS upgrade considerations across RHOAI 3.4, 3.5, and 3.6
- Create a pre-upgrade checklist and understand rollback limitations

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | RHOAI Release Cadence and Support Policy | 8 min |
| 2 | Exercise 1: Inspect Current RHOAI Operator Subscription and Version | 8 min |
| 3 | Exercise 2: Explore Available Update Channels and Versions | 8 min |
| 4 | Exercise 3: Inspect Dependent Operator Subscriptions | 8 min |
| 5 | Exercise 4: Demonstrate Manual Approval Strategy and Operator Pinning | 8 min |
| 6 | Conceptual: Minor Version Upgrade Workflow | 3 min |
| 7 | Conceptual: MaaS Version Differences + Pre-Upgrade Checklist | 5 min |

### Detailed Steps

1. Read the release cadence and life cycle support policy (Full Support / Maintenance / EUS)
2. Inspect the RHOAI subscription: `oc get subscription rhods-operator -n redhat-ods-operator -o yaml` (channel, source, installPlanApproval)
3. Inspect the CSV: owned CRDs, version, related images
4. Explore channels: `oc get packagemanifest rhods-operator -n openshift-marketplace` and compare stable/fast/eus channels
5. Audit dependent operators: `oc get subscriptions -A` and map which operators are pinned vs floating
6. Examine the DSC component management states (`oc get datasciencecluster -o json`) to see the meta-operator model
7. Review the manual-approval and pinning patterns (reference-only patches — DO NOT EXECUTE on the shared cluster)
8. Read the minor-version upgrade workflow, MaaS version comparison, and pre-upgrade checklist sections

### Key Takeaways

- RHOAI releases quarterly; the upgrade lifecycle is driven by OLM channels and InstallPlans.
- The rhods-operator is a meta-operator: one CSV pins the whole ODH component stack while external prerequisites (Serverless, Service Mesh, RHCL, GPU operator) upgrade independently.
- Operator pinning (explicit channels on dependent operators) prevents unintended upgrade combinations.
- OLM has no automatic rollback — the pre-upgrade checklist (DSC health, ClusterOperator checks, backups) is the safety net.

### Infrastructure Notes

- All exercises are inspect-and-plan; no upgrade is executed on the shared cluster.
- Patch commands (`oc patch subscription/installplan`) are shown reference-only with explicit DO NOT EXECUTE cautions.
- RHOAI and OpenShift lifecycles are managed independently within supported combinations (check the Supported Configurations matrix).
