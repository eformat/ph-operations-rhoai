# Module 02 — Data Stewardship, Users & Access Control

### Brief Overview

Module 2 models a data-stewardship organization — a line of business with data owners, data stewards, and data scientists — onto OpenShift groups, Data Science Projects, RoleBindings, and the RHOAI Auth CR. Six exercises verify the pre-provisioned FreeIPA persona groups, configure the RHOAI auth model, bind least-privilege roles for line-of-business projects and workbenches, prove the model with persona impersonation and dashboard walkthroughs (including the `dev-nia` denial path), and configure MaaS performance tiers bound to groups. The module ends with a reference table mapping the personas onto the full RHOAI RBAC surface area.

### Audience and Time

- **Target personas:** OCP platform administrators, MLOps engineers
- **Prerequisites for this module:** Module 1 completed; identity stack (FreeIPA + LDAP IdP + groups claim) pre-provisioned by the cluster layer
- **Estimated duration:** 60 minutes

### Learning Objectives

- Describe a data-stewardship organization model — a line of business with data owners, data stewards, and data scientists
- Explain how the organization model maps onto OpenShift groups, Data Science Projects, and RoleBindings
- Configure the RHOAI Auth CR (`adminGroups`, `allowedGroups`) to control dashboard access
- Configure MaaS performance tiers bound to groups for a line-of-business model
- Bind OpenShift roles to line-of-business projects for least-privilege access
- Create custom workbench roles for fine-grained notebook access control
- Verify RBAC decisions as different personas with `oc auth can-i` and the RHOAI dashboard
- Describe the full RBAC surface area across RHOAI subsystems and where identity comes into play

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Environment Setup: Identity Providers (pre-provisioned, verified) | 5 min |
| 2 | The Data Stewardship Organization Model | 5 min |
| 3 | Exercise 1: Verify the Federated Groups | 5 min |
| 4 | Exercise 2: Configure the RHOAI Auth CR | 8 min |
| 5 | Exercise 3: Line-of-Business Projects and RoleBindings | 10 min |
| 6 | Exercise 4: Least-Privilege Workbench Roles | 8 min |
| 7 | Exercise 5: Prove the Model — Persona Access Walkthrough | 10 min |
| 8 | Exercise 6: MaaS Permissions — Performance Tiers Bound to Groups | 10 min |

### Detailed Steps

1. Verify the pre-provisioned identity: `oc get groups` (persona groups arrive from FreeIPA via the OCP OAuth groups claim)
2. Apply the RHOAI Auth CR: `oc apply -f manifests/02-idp-users-groups/rhoai-auth/auth-config.yaml`
3. Create the LOB projects with the dashboard label: `oc new-project rhoai-lending` / `rhoai-insurance` + `opendatahub.io/dashboard=true`
4. Bind roles per group: `oc adm policy add-role-to-group admin|edit <lob>-data-{owners,stewards,scientists} -n rhoai-<lob>`
5. Apply custom workbench ClusterRoles and bind them: `oc adm policy add-cluster-role-to-group workbench-{maintainer,editor,operator} ...`
6. Prove RBAC: `oc auth can-i ... --as=<persona> --as-group=<group>` impersonation + dashboard logins (sci-eve, own-alice, dev-nia denial path)
7. Apply the MaaS governance manifests: `oc apply -f manifests/02-idp-users-groups/maas/subscription-*.yaml` + `authpolicy-*.yaml` (tenant namespace `models-as-a-service`)
8. Verify the Lending model MaaSModelRef converges to Ready after the projects + subscriptions exist
9. Review the RBAC surface area reference table (12 subsystems)

### Key Takeaways

- The data-stewardship model maps cleanly onto OpenShift groups + namespaced RoleBindings — LOB isolation comes from namespace scoping.
- RHOAI access is a separate gate from OpenShift login: the Auth CR's `allowedGroups`/`adminGroups` decide who reaches the dashboard.
- MaaS permission tiers are just MaaSSubscriptions bound to groups — the data owner decides who gets access and at what tier.
- Identity is GitOps pre-setup; the exercise verifies and consumes it (the exercise manifests are applied by hand to learn the process).

### Infrastructure Notes

- FreeIPA (realm FEDORACAPITAL.IO), the OCP-native LDAP IdP, and the groups claim are pre-provisioned by `automation/gitops/cluster/ops-ldap/` — nothing here needs manual setup.
- The Lending model (`qwen25-05b-maas`) is pre-setup via `automation/gitops/cluster/maas-model/` — the Application retries until Exercise 3 creates the `rhoai-lending` projects.
- The `models-as-a-service` tenant namespace is the only namespace `maas-api` reads subscriptions from.
- Known caution: the `view`-role workbench bug (dashboard vs API RBAC discrepancies) is documented in the module.
