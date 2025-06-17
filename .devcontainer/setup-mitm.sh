#!/bin/bash

# Setup script for mitm proxy dev container enhancements
echo "🔧 Setting up mitm proxy development environment..."

# Create useful aliases
echo "# mitm proxy aliases" >> ~/.bashrc
echo "alias mitm-start='mitmdump --web-host 0.0.0.0 --web-port 8081 --listen-port 8080'" >> ~/.bashrc
echo "alias mitm-web='mitmdump --web-host 0.0.0.0 --web-port 8081 --listen-port 8080 --web-open-browser'" >> ~/.bashrc
echo "alias mitm-logs='mitmdump --web-host 0.0.0.0 --web-port 8081 --listen-port 8080 --flow-detail 3'" >> ~/.bashrc
echo "alias mitm-ssl='mitmdump --web-host 0.0.0.0 --web-port 8081 --listen-port 8080 --set confdir=~/.mitmproxy'" >> ~/.bashrc

# Create mitm proxy configuration directory
mkdir -p ~/.mitmproxy

# Create a simple mitm proxy script for common usage patterns
cat > ~/start-mitm.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting mitm proxy..."
echo "📡 Proxy available at: http://localhost:8080"
echo "🌐 Web interface at: http://localhost:8081"
echo "📝 To configure your applications, set HTTP_PROXY=http://localhost:8080"
echo ""

mitmdump --web-host 0.0.0.0 --web-port 8081 --listen-port 8080 "$@"
EOF

chmod +x ~/start-mitm.sh

# Create example scripts directory
mkdir -p ~/mitm-examples

# Create example script for basic HTTP interception
cat > ~/mitm-examples/basic-intercept.py << 'EOF'
"""
Basic mitm proxy script for HTTP request/response interception
Usage: mitmdump -s basic-intercept.py
"""

from mitmproxy import http

def request(flow: http.HTTPFlow) -> None:
    """Log and optionally modify requests"""
    print(f"🔵 REQUEST: {flow.request.method} {flow.request.pretty_url}")
    
    # Example: Add custom headers
    # flow.request.headers["X-Custom-Header"] = "dev-container"

def response(flow: http.HTTPFlow) -> None:
    """Log and optionally modify responses"""
    print(f"🔴 RESPONSE: {flow.response.status_code} for {flow.request.pretty_url}")
    
    # Example: Log response content type
    if "content-type" in flow.response.headers:
        print(f"   Content-Type: {flow.response.headers['content-type']}")
EOF

# Create example script for API testing
cat > ~/mitm-examples/api-logger.py << 'EOF'
"""
API request/response logger for mitm proxy
Usage: mitmdump -s api-logger.py
"""

import json
from mitmproxy import http

def response(flow: http.HTTPFlow) -> None:
    """Log API requests and responses in detail"""
    if "api" in flow.request.pretty_url.lower() or "application/json" in flow.response.headers.get("content-type", ""):
        print(f"\n=== API CALL ===")
        print(f"URL: {flow.request.method} {flow.request.pretty_url}")
        print(f"Status: {flow.response.status_code}")
        
        # Log request body if JSON
        if flow.request.content and "application/json" in flow.request.headers.get("content-type", ""):
            try:
                req_data = json.loads(flow.request.content)
                print(f"Request Body: {json.dumps(req_data, indent=2)}")
            except:
                print(f"Request Body: {flow.request.content[:200]}...")
        
        # Log response body if JSON
        if flow.response.content and "application/json" in flow.response.headers.get("content-type", ""):
            try:
                resp_data = json.loads(flow.response.content)
                print(f"Response Body: {json.dumps(resp_data, indent=2)}")
            except:
                print(f"Response Body: {flow.response.content[:200]}...")
        
        print("=" * 40)
EOF

# Make example scripts executable
chmod +x ~/mitm-examples/*.py

echo "✅ mitm proxy setup complete!"
echo ""
echo "📚 Quick start commands:"
echo "  - mitm-start: Start mitm proxy with web interface"
echo "  - mitm-web: Start mitm proxy and open web interface"
echo "  - mitm-logs: Start mitm proxy with detailed logging"
echo "  - ~/start-mitm.sh: User-friendly startup script"
echo ""
echo "📁 Example scripts available in ~/mitm-examples/"
echo "🌐 Web interface will be available at http://localhost:8081"
echo "📡 Proxy will be available at http://localhost:8080"