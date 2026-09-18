#!/usr/bin/env python3
"""Provision this local demo at launch without putting credentials in source or arguments."""
from pathlib import Path
import base64
import json
import os
import subprocess
import sys

root = Path(__file__).resolve().parents[1]
if len(sys.argv) != 3 or sys.argv[1] not in ('device', 'simulator'):
    raise SystemExit('Usage: python3 scripts/launch-demo.py device|simulator DEVICE_ID')
mode, device = sys.argv[1:]
values = {}
for line in (root/'.env').read_text().splitlines():
    if '=' in line and not line.lstrip().startswith('#'):
        name, value = line.split('=',1)
        values[name.strip()] = value.strip().strip('"').strip("'")
connection = json.loads((root/'.demo/connection.json').read_text())
prefix = 'DEVICECTL_CHILD_' if mode == 'device' else 'SIMCTL_CHILD_'
environment = os.environ.copy()
environment[prefix+'ROASTED_SERVER_URL'] = connection['deviceURL' if mode == 'device' else 'simulatorURL']
environment[prefix+'ROASTED_DEMO_TOKEN'] = values['DEMO_ACCESS_TOKEN']
environment[prefix+'ROASTED_SERVER_CERT'] = base64.b64encode((root/'.demo/server-cert.der').read_bytes()).decode()
if mode == 'device':
    command = ['xcrun','devicectl','device','process','launch','--device',device,'--terminate-existing','dev.roasted.demo']
else:
    command = ['xcrun','simctl','launch','--terminate-running-process',device,'dev.roasted.demo']
result = subprocess.run(command, env=environment, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
# Do not echo CoreDevice diagnostics: they can include launch environment values.
print(f'Roasted {mode} launch: '+('succeeded' if result.returncode == 0 else 'failed (inspect device connection/signing)'))
raise SystemExit(result.returncode)
