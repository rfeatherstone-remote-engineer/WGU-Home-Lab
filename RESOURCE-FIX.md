# Lab Record: VM Optimization & MicroK8s Removal

## Issue Description
The `aarch64 Linux` Ubuntu guest virtual machine running inside UTM on macOS was consistently crashing or reverting to a **Suspended** state. The issue was heavily exacerbated when connecting an external IDE via a VS Code Remote-SSH session, causing sluggish terminal execution and process drops.

## Initial Diagnostics
Running `free -h` inside the guest terminal showed severe resource constraints on the allocated **3.3 GiB** of RAM:
* **Free Memory:** ~98 MiB
* **Available Headroom:** ~1.0 GiB
* **Swap Space Utilization:** 1.4 GiB (Indicating severe active memory swapping onto disk)

Running system control profiling via `systemd-cgtop -m` revealed that the largest memory footprints belonged to an idle Kubernetes instance running under snap management:
* `snap.microk8s.daemon-kubelite.service`: ~395.6M
* Supporting network and container runtimes (`dqlite`, `containerd`): ~140M+

## Resolution Action Plan
Since local Kubernetes clusters were not needed for the current development lifecycle, the package was decommissioned to free up user space environment memory.

```bash
# 1. Clear out active cluster configurations and states
microk8s reset

# 2. Stop the core background services safely
sudo microk8s stop

# 3. Completely purge the microk8s snap package binaries and data structures
sudo snap remove microk8s --purge
```

## Post-Execution Verification
Re-running memory diagnostics verified that the system reclaimed stable resource metrics:
* **Raw Free Memory:** Scaled up to **422 MiB**
* **Total Available Headroom:** Increased to **1.2 GiB**
* **System Stability:** Hypervisor suspension bugs resolved; smooth SSH pipeline operation restored for VS Code.

## Future Recommendations
If additional Docker containers or heavy development tooling are initialized in the `WGU-Home-Lab` workspace, the physical UTM hardware allocation should scale up from 3.3 GiB to a baseline of **4.0 GiB - 6.0 GiB** of RAM.
