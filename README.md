## ⚙️ Declarative Architecture & GitOps Control Loop

The diagram below outlines the deterministic lifecycle of this sandbox environment. Every infrastructure change is declared as code, validated upstream, and automatically synchronized to the local runtime environment to enforce a strict zero-drift baseline.

┌──────────────────────────────────────────────────────┐
│          Upstream GitHub Remote (GitOps IaC)         │
└──────────────────────────┬───────────────────────────┘
                           │ (Continuous Sync)
                           ▼
┌──────────────────────────────────────────────────────┐
│       Flux CD Engine (Automated Reconciliation)      │
└──────────────────────────┬───────────────────────────┘
                           │ (Desired State)
                           ▼
┌──────────────────────────────────────────────────────┐
│            Ubuntu VM Host (M1 Mac / UTM)             │
├──────────────────────────────────────────────────────┤
│ ├── [Terraform] ──> Local State Isolation            │
│ ├── [Docker]    ──> Nginx Web Bridge (8080:80)       │
│ ├── [K3s K8s]   ──> flux-system & Target Pods        │
│ └── [Python]    ──> system_monitor.py Telemetry      │
└──────────────────────────────────────────────────────┘
```
```

### 🎯 Architecture Execution Summary
* **Declarative Source of Truth:** Upstream configurations act as the immutable anchor for all infrastructure deployment files.
* **Automated Reconciliation Loop:** Flux CD continuously matches the running cluster state against the GitHub origin, completely mitigating manual configuration drift.
* **Resource-Budgeted Topology:** The entire runtime ecosystem is stripped of non-essential weight to operate flawlessly within a headless, 8GB unified memory boundary.









