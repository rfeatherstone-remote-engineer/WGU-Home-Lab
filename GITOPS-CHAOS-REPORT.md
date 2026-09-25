# Engineering Artifact: Declarative GitOps Self-Healing & Chaos Simulation Pipeline

## 1. Executive Summary
This report documents the architectural implementation and validation of an automated self-healing infrastructure pipeline. The objective of this sandbox laboratory was to verify system resilience against both application-level runtime failures and systemic configuration drift. The entire ecosystem is deployed on bare-metal virtualized ARM64 host architecture running under rigid hardware resource constraints (8GB Host RAM).

---

## 2. Architectural Blueprint & Component Topology
To maximize computing efficiency on a constrained host machine, concurrent standalone engines were deprecated, dedicating all localized resources to a lightweight Kubernetes control plane.

=================================================================================================================================================================================================================================================

* **Host Machine:** M1 Apple Silicon Mac (8GB Unified Memory)
* **Hypervisor Layer:** UTM running Headless Ubuntu ARM64 (Ubuntu-ARM64 VM Host)
* **Cluster Orchestration:** K3s Lightweight Kubernetes (`v1.x` Single-Node Control-Plane)
* **GitOps Automation Engine:** Flux CD (`flux-system` Core Controllers)
* **Target Application Layer:** Containerized `nginx:alpine` Deployment
* **State Management Strategy:** Fully declarative manifests synchronized via an isolated `Kustomization` overlay pattern.

---

## 3. Chaos Simulation Protocols & Empirical Metrics

### Test Case #1: Native Pod Eviction & Instantaneous Failover
* **Objective:** Verify the cluster's ability to recover from unexpected container process crashes or host node evictions.
* **Execution Methodology:** Force-deleted the target application runtime container instantly using maximum termination parameters:
  ```bash
  sudo kubectl delete pod <target-pod-id> --force --grace-period=0
  ```
* **System Telemetry Response:** 
  The replica-set controller registered a state mismatch within millisecond parameters. The cluster immediately moved the application container lifestyle sequence through `Terminating` ➔ `Pending` ➔ `ContainerCreating` ➔ `Running`.
* **Empirical Recovery Metric (MTTR):** ~3.0 seconds.

### Test Case #2: Configuration Drift & Declarative State Enforcement
* **Objective:** Verify system immunity against manual human error, unauthorized live environment tweaking, or configuration drift.
* **Execution Methodology:** Executed an unauthorized live manual intervention to scale the target system infrastructure completely down to zero replicas, simulating total application blackout:
  ```bash
  sudo kubectl scale deployment gitops-chaos-nginx --replicas=0
  ```
* **System Telemetry Response:** 
  The application deployment dropped instantly to `0/0` active pods. Upon triggering a GitOps synchronization check, the Flux CD reconciliation engine detected an integrity divergence between the live state engine and the declarative blueprint tracking inside the GitHub path `./clusters/my-cluster/flux-system/`. Flux invalidated the manual cluster override, issued an explicit roll-forward directive, and re-provisioned the missing deployment architecture.
* **Empirical Recovery Metric:** Automated alignment achieved immediately upon reconciliation loop verification.

---

## 4. Key Engineering Insights
1. **Immutable Infrastructure Realized:** Live cluster tampering is neutralized by a GitOps engine, ensuring the remote Git repository remains the singular source of operational truth.
2. **Resource Optimization Mastery:** Running enterprise-grade automation within an 8GB memory footprint proves that lightweight cloud-native stacks (K3s + Flux) can achieve zero-drift resiliency loops without heavy infrastructure overhead.
