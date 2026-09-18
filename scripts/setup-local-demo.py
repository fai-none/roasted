#!/usr/bin/env python3
"""Create a local TLS certificate. No provider credential is embedded in the app."""
from pathlib import Path
import json
import subprocess
import os

root = Path(__file__).resolve().parents[1]
private = root / '.demo'
private.mkdir(mode=0o700, exist_ok=True)
hostname = subprocess.check_output(['scutil', '--get', 'LocalHostName'], text=True).strip() + '.local'
try:
    address = subprocess.check_output(['ipconfig', 'getifaddr', 'en0'], text=True).strip()
except subprocess.CalledProcessError:
    address = '127.0.0.1'
config = private / 'certificate.cnf'
config.write_text(f'''[req]
distinguished_name=dn
x509_extensions=ext
prompt=no
[dn]
CN=Roasted Local Demo
[ext]
subjectAltName=DNS:localhost,DNS:{hostname},IP:127.0.0.1,IP:{address}
basicConstraints=critical,CA:TRUE
keyUsage=critical,digitalSignature,keyEncipherment,keyCertSign
extendedKeyUsage=serverAuth
''')
key, cert = private/'server-key.pem', private/'server-cert.pem'
if not key.exists() or not cert.exists():
    subprocess.run(['openssl','req','-x509','-newkey','rsa:2048','-sha256','-days','7','-nodes',
                    '-keyout',str(key),'-out',str(cert),'-config',str(config)],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    key.chmod(0o600)
subprocess.run(['openssl','x509','-in',str(cert),'-outform','DER','-out',str(private/'server-cert.der')], check=True)
(private/'connection.json').write_text(json.dumps({'deviceURL':f'https://{hostname}:8787','simulatorURL':'https://localhost:8787'}))
print('Local TLS certificate ready. Public hostname:', hostname)
print('Private key and local connection settings remain in ignored .demo/.')
