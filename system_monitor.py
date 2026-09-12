#!/usr/bin/env python3
import os
import sys
import time
import json
import logging
from datetime import datetime, timezone

logging.basicConfig(
    level=logging.INFO,
    format='%(message)s',
    handlers=[logging.StreamHandler(sys.stdout)]
)

def retrieve_system_metrics():
    try:
        with open('/proc/meminfo', 'r') as mem_file:
            lines = mem_file.readlines()
            
        mem_total = 1
        mem_available = 1
        for line in lines:
            if "MemTotal" in line:
                mem_total = int(line.split()[1])
            if "MemAvailable" in line:
                mem_available = int(line.split()[1])

        mem_used = mem_total - mem_available
        memory_utilization_percentage = round((mem_used / mem_total) * 100, 2)

        with open('/proc/loadavg', 'r') as load_file:
            load_averages = load_file.read().split()
            load_1min = float(load_averages[0])
            load_5min = float(load_averages[1])

        telemetry_packet = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "environment": "production-sandbox",
            "host_architecture": "ARM64/AArch64",
            "metrics": {
                "memory_total_kb": mem_total,
                "memory_used_kb": mem_used,
                "memory_utilization_pct": memory_utilization_percentage,
                "cpu_load_1min": load_1min,
                "cpu_load_5min": load_5min
            },
            "status": "HEALTHY" if memory_utilization_percentage < 85 else "WARN"
        }
        return json.dumps(telemetry_packet)

    except Exception as error_context:
        error_packet = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "status": "CRITICAL",
            "error_message": f"Telemetry retrieval failure: {str(error_context)}"
        }
        return json.dumps(error_packet)

def main():
    try:
        while True:
            metrics_payload = retrieve_system_metrics()
            logging.info(metrics_payload)
            time.sleep(10)
    except KeyboardInterrupt:
        sys.exit(0)

if __name__ == "__main__":
    main()
