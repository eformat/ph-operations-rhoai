# Module 01 — Operations Guidelines and Patterns

### Brief Overview

Module 1 is a discussion-heavy module on the core patterns and practices for operating a RHOAI platform. It introduces the "phoenix" platform-as-code pattern (destroy and rebuild rather than mutate), GitOps trunk-based git strategies, and the app-of-apps pattern with all three composition strategies (Helm charts, Kustomize overlays, raw YAML). The hands-on portion is a runnable dev/prod operator-install example that participants render, diff, and dry-run client-side — nothing is applied to the cluster. The module closes with conceptual coverage of ACM multi-cluster delivery, ACS security baselines, secrets-management strategy comparison, and SOP-as-code practices.

### Audience and Time

- **Target personas:** OCP platform administrators, MLOps engineers
- **Prerequisites for this module:** cluster-admin access, Getting Connected completed (manifests repo cloned)
- **Estimated duration:** 30 minutes

### Learning Objectives

- Describe the "phoenix" platform-as-code pattern and explain why it matters for RHOAI operations
- Explain the app-of-apps pattern using Helm charts, Kustomize overlays, and raw YAML
- Demonstrate GitOps self-healing by making a manual change and watching ArgoCD revert it
- Describe multi-cluster management with ACM and GitOps policy generation
- Navigate the ArgoCD UI and understand the different components of an ArgoCD Application
- Identify baseline security integration points with ACS
- Compare secrets management strategies (Vault, Age-SOPS, ExternalSecrets Operator)
- Describe the role of Standard Operating Procedures (SOPs) in day-2 operations

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | The Phoenix Pattern: Platform as Code | 4 min |
| 2 | GitOps, App-of-Apps Pattern and Git Strategies | 6 min |
| 3 | Worked Example: Changing DSC Config Between Environments | 8 min |
| 4 | Multi-Cluster Management with ACM and GitOps | 4 min |
| 5 | Baseline Security with ACS | 3 min |
| 6 | Secrets Management Strategies | 3 min |
| 7 | Standard Operating Procedures (SOPs) | 2 min |

### Detailed Steps

1. Read the phoenix pattern discussion (platform as code, GitOps self-healing)
2. Walk the `manifests/01-ops-patterns/` tree: bootstrap app-of-apps, per-environment Applications, Kustomize base, env overlays, ACM PolicyGenerator
3. Render the dev and prod operator installs with Helm: `helm template rhoai-operators envs/{dev,prod}/charts/rhoai-operators`
4. Build both environments with Kustomize: `kustomize build --enable-alpha-plugins --enable-helm envs/dev` (and prod)
5. Diff the environments side by side with process substitution
6. Validate client-side without applying: `kustomize build ... | oc apply --dry-run=client -f -`
7. View the ACM PolicyGenerator wrapping both environments
8. Apply the app-of-apps root once (`oc apply -f bootstrap/app-of-apps.yaml`) and observe ArgoCD create the child Applications
9. Explore ACM architecture, ACS integration points, secrets strategies, and SOP-as-code conceptually

### Key Takeaways

- Platform-as-code means the entire RHOAI platform is declaratively defined and rebuildable — the "phoenix" pattern.
- The app-of-apps pattern composes Helm, Kustomize, and raw YAML into a single ArgoCD-managed tree.
- ArgoCD self-healing reverts manual changes; ACM extends GitOps policy delivery across clusters.
- Secrets never live in git — strategy comparison: Vault, Age-SOPS, External Secrets Operator.

### Infrastructure Notes

- ArgoCD (openshift-gitops) is pre-provisioned by the cluster layer — the module inspects, not installs.
- The worked example is render-only on the shared cluster; `oc apply` is shown for the app-of-apps root only.
