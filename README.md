# Localized GitOps Multi-Tool Sandbox: ARM64 Infrastructure & Telemetry

An automated, localized multi-tool sandbox environment natively optimized for ARM64/AArch64 architectures inside an Ubuntu Virtual Machine. This repository demonstrates infrastructure orchestration via Declarative Configuration Management (IaC), secure cryptographic network loops, containerized application delivery, and deterministic performance telemetry.

## 🏗️ System Architecture & Connectivity

```text
[ Local Client Machine ] 
       │
       ▼ (VS Code Remote-SSH Socket via Cryptographic Asymmetric Keys)
[ Ubuntu-ARM64 VM Host ]
       │
       ├───► [ Terraform Engine ] ──► (Local State Management & Isolation Rules)
       │
       └───► [ Docker Engine ]
                   │
                   ▼ (Deterministic Bridge Mapping / Port 8080:80 Ingress)
             [ Containerized Nginx Web Server ]
```

---

## 🛠️ Core Engineering Implementations

### 1. Secure Cryptographic Access Architecture
* **Host Provisioning:** Deployed an openSSH-server daemon natively inside an isolated Ubuntu-ARM64 environment to support headless operational workflows.
* **Authentication Hardening:** Enforced cryptographic key-based authentication utilizing asymmetric key pairs. Managed secure public key distribution via `ssh-copy-id` to systematically mitigate vulnerable password-based threat vectors.
* **Headless Development Loop:** Integrated the VS Code Remote-SSH extensions to create an encrypted operational socket directly into the target execution environment, separating local client compute from heavy backend workloads.

### 2. Infrastructure-as-Code & Immutable Application Delivery
* **State Isolation Discipline:** Executed localized Terraform configurations under a strict GitOps delivery lifecycle. Prevented environment metadata contamination and security leaks by maintaining strict tracking boundaries (`.tfstate`, `.tfstate.backup`) via targeted `.gitignore` policies.
* **Containerized Recipe Design:** Engineered a lightweight, multi-stage Dockerfile recipe to build, isolate, and host a high-performance Nginx web server environment.
* **VPC Ingress Validation:** Established deterministic bridge networking to route traffic through internal port-forwarding architectures (Host Network to Container Ingress). Verified standard OSI network layer handshakes before triggering automated lifecycle termination scripts.

### 3. Algorithmic Systems Telemetry
* **Telemetry Automation:** Authored algorithmic Python utility engines (`system_monitor.py`) to systematically monitor hardware utilization without polling overhead.
* **Persistence Engineering:** Programmed standardized append loops to stream runtime performance diagnostics cleanly into tracking databases (`system_health.log`), modeling production event-driven logging frameworks.

---

## 📂 Repository Structure

```text
├── Docker-folder/
│   └── Dockerfile               # Multi-stage Nginx compilation recipe
├── Terraform-folder/
│   ├── main.tf                  # Localized IaC provisioning configurations
│   └── terraform.tfstate        # [EXCLUDED VIA GITIGNORE] Local state tracking
├── .gitignore                   # Operational boundary protocol rules
├── README.md                    # System architecture documentation
├── quick_push.sh                # Automation pipeline sync utility
├── system_health.log            # Telemetry tracking output destination
└── system_monitor.py            # Automated hardware metric retrieval engine
```

---

## ⚡ Execution & Verification Workflows

### Infrastructure Provisioning
```bash
cd Terraform-folder/
terraform init
terraform apply -auto-approve
```

### Application Runtime Lifecycle
```bash
cd ../Docker-folder/
docker build -t localized-web-ingress:v1 .
docker run -d -p 8080:80 --name production-ingress localized-web-ingress:v1
```

### Telemetry Initialization
```bash
python3 system_monitor.py >> system_health.log &
```

