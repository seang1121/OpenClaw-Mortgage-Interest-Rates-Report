#!/usr/bin/env bash
# OpenClaw Mortgage Rate Integration — One-command setup
# Usage: bash install.sh [ZIP_CODE]
#
# What this does:
#   1. Clones the scraper into your OpenClaw workspace
#   2. Installs patchright + stealth Chromium
#   3. Sets your ZIP code
#   4. Registers a daily cron job in OpenClaw
#
# After install, you get daily mortgage rates delivered to your Discord.

set -e

REPO_URL="https://github.com/seang1121/openclaw-mortgage-rates.git"
INSTALL_DIR="$HOME/.openclaw/workspace/mortgage-rates"
CRON_FILE="$HOME/.openclaw/cron/jobs.json"
ZIP="${1:-}"

echo ""
echo "  Mortgage Rate Scanner — OpenClaw Integration"
echo "  ============================================="
echo ""

# Step 1: Check OpenClaw is running
if ! command -v openclaw &>/dev/null; then
    echo "  ERROR: openclaw CLI not found."
    echo "  Install OpenClaw first: https://openclaw.ai"
    exit 1
fi

echo "  [1/5] Checking OpenClaw gateway..."
if curl -s --max-time 3 http://127.0.0.1:18789 >/dev/null 2>&1; then
    echo "         Gateway is running."
else
    echo "  WARNING: Gateway not responding on port 18789."
    echo "           Make sure OpenClaw is running: pm2 start openclaw"
    echo ""
fi

# Step 2: Clone or update the scraper
echo "  [2/5] Installing scraper..."
if [ -d "$INSTALL_DIR" ]; then
    echo "         Updating existing install..."
    cd "$INSTALL_DIR" && git pull --quiet
else
    git clone --quiet "$REPO_URL" "$INSTALL_DIR"
fi

# Step 3: Install dependencies
echo "  [3/5] Installing dependencies..."
cd "$INSTALL_DIR"
python3 -m venv venv 2>/dev/null || python -m venv venv 2>/dev/null
source venv/bin/activate 2>/dev/null || source venv/Scripts/activate 2>/dev/null
pip install -q -r requirements.txt
python -m patchright install chromium 2>/dev/null
deactivate 2>/dev/null || true

# Step 4: Configure ZIP code
if [ -z "$ZIP" ]; then
    echo ""
    read -p "  Enter your ZIP code (e.g. 90210): " ZIP
fi

if [ -n "$ZIP" ]; then
    echo "{\"zip_code\": \"$ZIP\"}" > "$INSTALL_DIR/config.json"
    echo "  [4/5] ZIP code set to $ZIP"
else
    echo "  [4/5] No ZIP code set — using default (32224)"
fi

# Step 5: Register OpenClaw cron job
echo "  [5/5] Registering cron job..."

# Generate a unique job ID
JOB_ID="mortgage-rates-$(date +%s)"

# Check if jobs.json exists and has a jobs array
if [ -f "$CRON_FILE" ]; then
    # Check if a mortgage rate job already exists
    if python3 -c "
import json
with open('$CRON_FILE') as f:
    jobs = json.load(f)
existing = [j for j in jobs['jobs'] if 'mortgage' in j['name'].lower()]
if existing:
    print('EXISTS')
" 2>/dev/null | grep -q "EXISTS"; then
        echo "         Mortgage rate job already registered — skipping."
        echo ""
        echo "  Done! Your existing mortgage rate job will use the updated scraper."
        echo "  To run manually: openclaw run mortgage-rates"
        echo ""
        exit 0
    fi

    # Add the new job
    python3 -c "
import json, time, uuid

with open('$CRON_FILE') as f:
    data = json.load(f)

now_ms = int(time.time() * 1000)

job = {
    'id': '$JOB_ID',
    'name': 'daily-mortgage-rates',
    'enabled': True,
    'createdAtMs': now_ms,
    'updatedAtMs': now_ms,
    'schedule': {
        'kind': 'cron',
        'expr': '0 8 * * *',
        'tz': 'America/New_York'
    },
    'sessionTarget': 'isolated',
    'wakeMode': 'now',
    'payload': {
        'kind': 'agentTurn',
        'message': 'MORTGAGE RATE REPORT: Run this command:\ncd $INSTALL_DIR && source venv/bin/activate && python3 mortgage_rate_report.py 2>&1\n\nRead the full output and reply with it formatted for Discord. Do NOT use the message tool.',
        'timeoutSeconds': 300
    },
    'delivery': {
        'mode': 'announce',
        'channel': 'discord'
    },
    'state': {
        'consecutiveErrors': 0
    }
}

data['jobs'].append(job)
with open('$CRON_FILE', 'w') as f:
    json.dump(data, f, indent=2)
print('REGISTERED')
"
    echo "         Cron job registered: daily at 8:00 AM EST"
else
    echo "  WARNING: $CRON_FILE not found."
    echo "           You can register the job manually with:"
    echo "           openclaw cron create --name daily-mortgage-rates --expr '0 8 * * *'"
fi

echo ""
echo "  ============================================="
echo "  Setup complete!"
echo ""
echo "  What happens now:"
echo "    - Every day at 8:00 AM EST, OpenClaw scrapes 10 lenders"
echo "    - Rates are ranked lowest to highest with national benchmarks"
echo "    - Report is delivered to your Discord channel"
echo ""
echo "  To test now:"
echo "    cd $INSTALL_DIR"
echo "    source venv/bin/activate"
echo "    python3 mortgage_rate_report.py"
echo ""
echo "  To change your ZIP: edit $INSTALL_DIR/config.json"
echo "  To change schedule: edit $CRON_FILE (find 'daily-mortgage-rates')"
echo ""
