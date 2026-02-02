#!/bin/bash

# Build and push Docker images for Aura v2 ML Daemons
set -e

REGISTRY="vekiosnicola"
VERSION="v2.0.0"

echo "🚀 Building Aura v2 ML Daemon images..."

for service in failure-prediction auto-scaling-ml inference-routing-optimizer; do
    echo "Building ${service}..."
    
    cat > Dockerfile.${service} << EOF
FROM alpine:latest
RUN apk add --no-cache python3 py3-pip curl
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:\$PATH"
RUN /opt/venv/bin/pip install flask prometheus-client
WORKDIR /app
COPY <<'PYEOF' /app/main.py
from flask import Flask, jsonify
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
import time
import random

app = Flask(__name__)
REQUESTS = Counter('requests_total', 'Total requests', ['method', 'endpoint'])
LATENCY = Histogram('request_latency_seconds', 'Request latency')

@app.route('/healthz')
@LATENCY.time()
def healthz():
    REQUESTS.labels(method='GET', endpoint='/healthz').inc()
    return jsonify({"status": "healthy", "service": "${service}"})

@app.route('/readyz')
@LATENCY.time()
def readyz():
    REQUESTS.labels(method='GET', endpoint='/readyz').inc()
    return jsonify({"status": "ready", "service": "${service}"})

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
PYEOF

EXPOSE 8080
CMD ["python3", "main.py"]
EOF

    docker build -f Dockerfile.${service} -t ${REGISTRY}/${service}:${VERSION} .
    docker build -f Dockerfile.${service} -t ${REGISTRY}/${service}:latest .
    
    echo "✅ ${service} built successfully"
    rm -f Dockerfile.${service}
done

echo "📦 All images built. To push to registry:"
echo "docker push ${REGISTRY}/failure-prediction:${VERSION}"
echo "docker push ${REGISTRY}/auto-scaling-ml:${VERSION}"
echo "docker push ${REGISTRY}/inference-routing-optimizer:${VERSION}"

echo "✅ Build complete!"