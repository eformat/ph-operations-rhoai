# Module 05 — Observe & Debug

### Brief Overview

Module 5 covers observing and debugging a RHOAI platform. Participants tour the built-in RHOAI 3.5 monitoring stack (Prometheus, Thanos querier, Alertmanager, OpenTelemetry collector) and the console Observe dashboards, then query model serving metrics with PromQL (inference latency, throughput, error rates) and create a PrometheusRule alert. They configure Prometheus remote-write to export RHOAI metrics to an external monitoring stack, and read RHOAI audit and operator logs through the OpenShift logging subsystem. Conceptual sections cover the llm-d Perses observability dashboards and the MaaS external metering architecture planned for RHOAI 3.6.

### Audience and Time

- **Target personas:** OCP platform administrators, MLOps engineers
- **Prerequisites for this module:** Modules 1–4 completed; the RHOAI monitoring stack is pre-installed with RHOAI
- **Estimated duration:** 40 minutes

### Learning Objectives

- Navigate the built-in RHOAI 3.5 monitoring dashboards and interpret key platform metrics
- Query model serving metrics (inference latency, throughput, error rates) with PromQL
- Configure Prometheus remote-write to export RHOAI metrics to an external monitoring stack
- Locate and read RHOAI audit logs through the OpenShift logging subsystem
- Describe the llm-d Perses observability dashboards and their role in LLM serving visibility
- Describe the MaaS external metering architecture planned for RHOAI 3.6

### Lab Structure

| Section | Title | Duration |
|---------|-------|----------|
| 1 | Exercise 1: Explore RHOAI Dashboard Monitoring | 8 min |
| 2 | Exercise 2: Query Model Serving Metrics with Prometheus | 10 min |
| 3 | Exercise 3: Configure Metrics Export via Remote-Write | 10 min |
| 4 | Exercise 4: View RHOAI Audit Logs | 5 min |
| 5 | Conceptual: llm-d Perses Observability Dashboards | 4 min |
| 6 | Conceptual: MaaS External Metering Architecture | 3 min |

### Detailed Steps

1. Explore the console Observe → Dashboards/Metrics views for the data-science monitoring stack
2. Query model serving metrics via the Prometheus API: latency (`histogram_quantile` p99 e2e/ITL), throughput (`request_success_total`), error rates
3. Create a PrometheusRule alert for model serving and verify it appears
4. Configure remote-write: patch `cluster-monitoring-config` with `remoteWrite` + `writeRelabelConfigs` keep-filters and a credentials Secret
5. Watch the remote-write pods roll out and verify the export path
6. Read audit logs: `oc adm node-logs --role=master --path=kube-apiserver/`
7. Read operator/component logs: rhods-operator, rhods-dashboard, kserve-controller-manager
8. Read the llm-d Perses dashboards and MaaS external metering concept sections

### Key Takeaways

- RHOAI ships its own monitoring stack (redhat-ods-monitoring) separate from platform monitoring.
- Model serving metrics follow the `kserve_vllm:*` family — latency, throughput, and error-rate PromQL queries are the daily drivers.
- Remote-write exports RHOAI metrics to external TSDBs (Datadog, Grafana Cloud, Splunk, Thanos) with relabel keep-filters.
- The MaaS external metering architecture (3.6 Dev/TP) extends observability to token-level usage accounting.

### Infrastructure Notes

- The monitoring stack is installed as part of RHOAI (DSC component) — no setup required.
- Remote-write requires a placeholder external endpoint; the exercise uses a placeholder URL + credentials Secret.
- User workload monitoring (UWM) is enabled by the cluster layer (cluster-monitoring-config) for model metrics.
