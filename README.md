# almost-empty

yep. this is it.

## 🕸️ mitm proxy Dev Container

This repository includes an enhanced dev container with mitm proxy for network debugging and development.

### Quick Start

1. Open in VS Code with Dev Containers extension
2. The container will automatically set up mitm proxy with web interface
3. Access the web interface at `http://localhost:8081`
4. Configure applications to use proxy at `http://localhost:8080`

### Available Commands

After the container starts, you'll have these convenient aliases:

```bash
mitm-start      # Start mitm proxy with web interface
mitm-web        # Start mitm proxy and open web interface  
mitm-logs       # Start mitm proxy with detailed logging
mitm-ssl        # Start mitm proxy with SSL certificate handling
```

Or use the user-friendly script:
```bash
~/start-mitm.sh
```

### Example Usage

#### Basic HTTP Interception
```bash
# Start the proxy
mitm-start

# In another terminal, test with curl
curl -x http://localhost:8080 http://httpbin.org/json
```

#### Using Custom Scripts
```bash
# Run with example logging script
mitmdump -s ~/mitm-examples/basic-intercept.py

# Run with API logging script  
mitmdump -s ~/mitm-examples/api-logger.py
```

### Environment Variables

- `MITM_PROXY_PORT=8080` - Proxy port
- `MITM_WEB_PORT=8081` - Web interface port  
- `MITM_PROXY_HOST=0.0.0.0` - Proxy host

### VS Code Extensions

The dev container includes helpful extensions:
- REST Client - Test APIs directly in VS Code
- Thunder Client - Alternative REST client
- Hex Editor - View binary data
- Code Spell Checker - Documentation quality

### Certificate Installation

For HTTPS interception, install the mitm proxy certificate:

1. Start mitm proxy: `mitm-start`
2. Visit `http://mitm.it` in your browser (through the proxy)
3. Download and install the certificate for your platform
