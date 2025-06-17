# Advanced mitm proxy Usage

This document provides advanced usage patterns for the enhanced mitm proxy dev container.

## Custom Scripts

### Creating Interception Scripts

Create custom Python scripts in `~/mitm-examples/` to extend functionality:

```python
"""
Custom script example: modify-responses.py
"""
from mitmproxy import http

def response(flow: http.HTTPFlow) -> None:
    if "api.example.com" in flow.request.pretty_url:
        # Add custom headers to responses from specific domains
        flow.response.headers["X-Custom-Debug"] = "modified-by-mitm"
```

Run with: `mitmdump -s ~/mitm-examples/modify-responses.py`

### Request Modification

```python
def request(flow: http.HTTPFlow) -> None:
    # Redirect requests
    if "old-api.com" in flow.request.pretty_url:
        flow.request.url = flow.request.url.replace("old-api.com", "new-api.com")
    
    # Add authentication headers
    if "secure-api.com" in flow.request.pretty_url:
        flow.request.headers["Authorization"] = "Bearer dev-token"
```

## Configuration Options

### Custom mitm proxy startup

Use the configuration file `.devcontainer/mitm-config.yaml`:

```bash
mitmdump --conf .devcontainer/mitm-config.yaml
```

### SSL Certificate Setup

For HTTPS interception:

1. Start mitm proxy: `mitm-start`
2. Visit `http://mitm.it` through the proxy
3. Download certificate for your platform
4. Install in your system's certificate store

### Environment-Specific Configuration

Set these environment variables in your `.devcontainer/devcontainer.json`:

```json
"containerEnv": {
  "MITM_PROXY_PORT": "8080",
  "MITM_WEB_PORT": "8081", 
  "MITM_SCRIPTS_DIR": "~/mitm-examples",
  "MITM_CONFIG_FILE": ".devcontainer/mitm-config.yaml"
}
```

## Common Use Cases

### API Development

1. **Request/Response Logging**: Use `api-logger.py` script
2. **Mock Responses**: Create scripts that return mock data
3. **Rate Limiting Testing**: Add delays to responses
4. **Header Injection**: Add custom headers for testing

### Security Testing

1. **Certificate Analysis**: Inspect SSL/TLS handshakes
2. **Request Tampering**: Modify requests in flight
3. **Response Manipulation**: Alter server responses
4. **Protocol Analysis**: Examine HTTP/2, WebSocket traffic

### Performance Testing

1. **Latency Simulation**: Add artificial delays
2. **Bandwidth Throttling**: Limit connection speeds
3. **Connection Analysis**: Monitor connection patterns
4. **Cache Behavior**: Test caching mechanisms

## Troubleshooting

### Common Issues

1. **Proxy Connection Refused**: Ensure mitm proxy is running on port 8080
2. **SSL Errors**: Install mitm proxy certificate for HTTPS
3. **Performance Issues**: Check if scripts are blocking
4. **Port Conflicts**: Verify ports 8080/8081 are available

### Debug Commands

```bash
# Test proxy connectivity
curl -x http://localhost:8080 http://httpbin.org/ip

# Check if web interface is accessible
curl http://localhost:8081

# Verbose logging
mitmdump --verbose --web-host 0.0.0.0 --web-port 8081
```

## Integration Examples

### With Python requests

```python
import requests

proxies = {'http': 'http://localhost:8080', 'https': 'http://localhost:8080'}
response = requests.get('https://api.example.com/data', proxies=proxies)
```

### With curl

```bash
curl -x http://localhost:8080 https://api.example.com/data
```

### With Node.js

```javascript
const https = require('https');
const options = {
  hostname: 'api.example.com',
  port: 443,
  path: '/data',
  method: 'GET',
  agent: new https.Agent({
    host: 'localhost',
    port: 8080
  })
};
```