import os
import shutil
import subprocess

print("=========================================")
print("     ENTERPRISE SYSTEM HEALTH CHECK      ")
print("=========================================")

# 1. Check Disk Space Usage (converts raw bytes into Gigabytes)
total, used, free = shutil.disk_usage("/")
print(f"💾 Disk Space Total: {total // (2**30)} GB")
print(f"💾 Disk Space Used : {used // (2**30)} GB")

free_gb = free // (2**30)
if free_gb < 5:
    print(" WARNING: LOW DISK SPACE!")
else: 
    print(" Disk health status: OPTIONAL.")
# 2. Check System Memory (RAM) allocation using native Linux tools
print("\n🧠 Memory Allocation Status (in MB):")
subprocess.run(["free", "-m"])

# 3. Check System Uptime (How long has this server been running?)
print("\n⏱️  System Uptime Status:")
subprocess.run(["uptime"])
print("=========================================")
