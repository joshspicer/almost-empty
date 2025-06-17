#!/usr/bin/env python3
"""
Example script demonstrating HTTP requests through mitm proxy
"""

import requests
import os

# Get proxy configuration from environment
proxy_host = os.getenv('MITM_PROXY_HOST', 'localhost')
proxy_port = os.getenv('MITM_PROXY_PORT', '8080')
proxy_url = f"http://{proxy_host}:{proxy_port}"

print(f"🔗 Using proxy: {proxy_url}")
print("📝 Make sure mitm proxy is running: mitm-start")
print()

# Configure requests to use the proxy
proxies = {
    'http': proxy_url,
    'https': proxy_url,
}

try:
    # Test HTTP request
    print("🌐 Making HTTP request to httpbin.org...")
    response = requests.get('http://httpbin.org/json', proxies=proxies, timeout=10)
    print(f"✅ Status: {response.status_code}")
    print(f"📄 Response: {response.json()}")
    print()
    
    # Test another endpoint
    print("🌐 Making request to get IP info...")
    response = requests.get('http://httpbin.org/ip', proxies=proxies, timeout=10)
    print(f"✅ Status: {response.status_code}")
    print(f"📄 Response: {response.json()}")
    
except requests.exceptions.ProxyError:
    print("❌ Proxy connection failed!")
    print("💡 Make sure mitm proxy is running: mitm-start")
except requests.exceptions.RequestException as e:
    print(f"❌ Request failed: {e}")
except Exception as e:
    print(f"❌ Error: {e}")

print()
print("🌐 Check the mitm proxy web interface at http://localhost:8081")
print("📡 You should see the captured traffic there!")