# Module 03 — Managing Models and Assets at Scale

### Brief Overview

Module 3 is a hands-on asset-lifecycle module: participants build a custom workbench image via OpenShift Builds and expose it through a labeled ImageStream, package a model as a scratch-based ModelCar OCI image and serve it with KServe using the `oci://` storage URI, and register a model in the RHOAI model registry over its REST API. Three large conceptual sections cover Kueue GPU scheduling (with a real CPU-only demo quota tree), MIG/DRA GPU partitioning strategies, and llm-d serving topologies with the EPP scheduler. A hardware-profile inspection exercise closes the module.

### Audience and Time

- **Target personas:** OCP platform administrators, MLOps engineers
- **Prerequisites for this module:** Modules 1–2 completed; model registry and Kueue pre-provisioned by the cluster layer
- **Estimated duration:** 60 minutes

### Learning Objectives

- Build a custom workbench image and import it into RHOAI via an ImageStream CRD
- Build a ModelCar OCI container image and deploy it with KServe
- Register a model in the RHOAI model registry and inspect its metadata
- Explain Kueue resource management concepts: ClusterQueues, LocalQueues, ResourceFlavors, and Cohorts
- Describe MIG, dynamic MIG, and DRA GPU partitioning strategies
- Describe llm-d serving topologies including single-node, multi-node data parallelism, prefill/decode disaggregation, and WideEP, plus the EPP scheduler, distributed KV cache, and WVA autoscaling
- Inspect and describe hardware profiles with node selectors, taints, and tolerations

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Exercise 1: Build and Import a Custom Workbench Image | 12 min |
| 2 | Exercise 2: Build a ModelCar OCI Container | 10 min |
| 3 | Exercise 3: Register a Model in the Model Registry | 10 min |
| 4 | Conceptual: Kueue GPU Scheduling + demo quota tree | 12 min |
| 5 | Conceptual: MIG, Dynamic MIG, and DRA | 5 min |
| 6 | Conceptual: llm-d Serving Topologies and the EPP Scheduler | 8 min |
| 7 | Exercise 4: Inspect Hardware Profiles | 3 min |

### Detailed Steps

1. Build the custom workbench image: `oc new-build --binary --strategy=docker` + `oc start-build --from-dir --follow`
2. Apply the labeled ImageStream so RHOAI discovers it (`opendatahub.io/notebook-image` label)
3. Create the pickle model artifact and build the ModelCar OCI image as a scratch container
4. Serve the ModelCar: apply the InferenceService with `storageUri: oci://…` (RawDeployment) and wait for Ready
5. Register the model in the Model Registry REST API: `registered_models` → `model_versions` → `model_artifacts`
6. Inspect the Kueue demo quota tree on the lab cluster: `oc get cohort`, `clusterqueues`, `localqueues`
7. Create a LocalQueue in your project pointing at the demo ClusterQueue
8. Read the MIG/DRA and llm-d topology concept sections
9. Inspect hardware profiles and accelerator profiles: `oc get hardwareprofiles` + node labels/taints

### Key Takeaways

- Custom workbench images are discovered via labeled ImageStreams; builds run in-cluster (OpenShift Builds).
- ModelCars package model weights as OCI images — KServe mounts them via image volumes; no PVCs or S3 required.
- The Model Registry tracks registered models/versions/artifacts over a REST API backed by Postgres.
- Kueue manages quotas with Cohorts/ClusterQueues/LocalQueues; MIG/DRA partition GPUs (conceptual on the CPU-only lab).

### Infrastructure Notes

- The model registry (Postgres, `rhoai-model-registries` ns) and Kueue (`stable-v1.4` + demo quota tree) are pre-provisioned by the cluster layer.
- No GPU nodes on the lab cluster — Kueue/MIG/llm-d sections are conceptual; node GPU-label checks expect empty results.
- The bastion has no podman socket — builds use OpenShift Builds, not local container tools.
