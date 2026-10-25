# ph-operations-rhoai

RHOAI 3.5 Operations Workshop — a hands-on, day-2 operations lab that walks platform administrators and MLOps engineers through operating Red Hat OpenShift AI at scale: platform-as-code with GitOps and ACM, data stewardship and RBAC, models and assets at scale, the upgrade lifecycle, observability, and backup/DR with OADP.

**Owner:** eformat
**Migrated from:**
- https://github.com/rhai-code/zt-rhoai-operations-showroom (showroom content)
- https://github.com/rhai-code/zt-rhoai-operations-automation (GitOps automation)

---

## Repo layout

Publishing House project format:

| Path | Purpose |
|------|---------|
| `content/` | Showroom AsciiDoc content (Antora component `modules`) |
| `manifests/` | Learner-facing exercise manifests (01-ops-patterns, 02-idp-users-groups, 03-models-assets-scale) |
| `automation/gitops/cluster/` | Two-layer GitOps app-of-apps: RHOAI install, MaaS platform, FreeIPA/LDAP identity, per-module workloads |
| `automation/showroom-deployer/` | Helm values for deploying the workshop showroom UI |
| `publishing-house/` | Project spec, design doc, module outlines, tools |
| `qa-automation/` | Health check and e2e test playbooks |
| `catalog-info.yaml` | Developer Hub catalog descriptor |

## What was set up

1. Repository created (migrated from the Showroom + automation repos)
2. `catalog-info.yaml` added to repository
3. Registered in Developer Hub catalog
4. Orchestrator workflow started — your AI-guided content pipeline is running!

## What happens next

Claude will walk you through the entire content lifecycle — from intake and spec creation, through Jira tracking and reviews, all the way to a published lab on RHDP. Just follow the prompts!

## Getting started

### DevSpaces (recommended)

1. Open in DevSpaces: `https://devspaces.apps.ocpv-infra02.wdc07.infra.demo.redhat.com#https://github.com/rhpds/ph-operations-rhoai`
2. Use Claude via the **extension** or the **CLI**:
   - **Extension:** Click the **Claude** icon in the sidebar, click **New Session**. If the Claude icon is not visible, open **Extensions** (`Ctrl/Cmd+Shift+X`), find **Claude Code for VS Code** under the DevSpaces section, click it, then click **Enable (Workspace)**.
   - **CLI:** Open a terminal and run `claude`
3. Run `/rhdp-publishing-house` — and you're off!

### Local machine

1. Install the skills:
   ```
   git clone -b prod https://github.com/rhpds/rhdp-publishing-house-skills.git ~/.claude/skills/publishing-house
   ```
2. Clone the repo:
   ```
   git clone https://github.com/rhpds/ph-operations-rhoai
   ```
3. `cd ph-operations-rhoai`
4. Start Claude CLI: `claude`
5. Run `/rhdp-publishing-house` — and you're off!

## Building the docs

```bash
make install build   # or: make serve  (http://localhost:8887)
```

## Deploying the workshop showroom

```bash
make repo template deploy   # zt-showroom-deployer chart, values in automation/showroom-deployer/
```
