#!/bin/bash

echo "========================================="
echo "🚀 STARTING AUTOMATED PORTFOLIO SYNC..."
echo "========================================="

# 1. Stage all new and modified files in this directory
git add .

# 2. Commit the changes with an automated timestamp message
git commit -m "Auto-sync lab: $(date +'%Y-%m-%d %H:%M:%S')"

# 3. Push upstream to your public GitHub profile
git push origin main

echo "========================================="
echo "✅ PORTFOLIO SYNC COMPLETE!"
echo "========================================="
