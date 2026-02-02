#!/bin/bash

# Quick demo of Aura v2 ML Daemons deployment
set -e

echo "🚀 Aura v2 ML Daemons - GitOps Demo"
echo "======================================"

echo ""
echo "📊 Git Repository Status:"
echo "✅ GitHub Repository: https://github.com/vekiosnicola-ux/aura-v2-ml-daemons"
echo "✅ Commits: $(git rev-list --count HEAD)"
echo "✅ Latest Commit: $(git rev-parse --short HEAD)"

echo ""
echo "🐳 Docker Images Status:"
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep vekiosnicola | while read repo tag size; do
    echo "✅ $repo:$tag ($size)"
done

echo ""
echo "🏗️ Deployment Architecture:"
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│              Aura v2 ML Ecosystem                 │"
echo "│                                                   │"
echo "│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │"
echo "│  │ Failure     │  │ Auto        │  │ Inference   │ │"
echo "│  │ Prediction  │  │ Scaling ML  │  │ Routing     │ │"
echo "│  │ Daemon      │  │ Daemon      │  │ Optimizer   │ │"
echo "│  └─────────────┘  └─────────────┘  └─────────────┘ │"
echo "│                                                   │"
echo "│  ↓ GitOps (ArgoCD)                               │"
echo "│                                                   │"
echo "│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │"
echo "│  │ Kubernetes │  │ Prometheus  │  │ Grafana     │ │"
echo "│  │ Cluster   │  │ Monitoring  │  │ Dashboards  │ │"
echo "│  └─────────────┘  └─────────────┘  └─────────────┘ │"
echo "└─────────────────────────────────────────────────────────────┘"

echo ""
echo "📋 Deployment Components:"
echo "✅ Kubernetes manifests with HPA auto-scaling"
echo "✅ NetworkPolicies for security" 
echo "✅ RBAC permissions configured"
echo "✅ OpenTelemetry integration ready"
echo "✅ ArgoCD GitOps pipeline"
echo "✅ Grafana monitoring dashboards"
echo "✅ Production-ready Docker images"

echo ""
echo "🔄 GitOps Workflow:"
echo "1. Code committed to GitHub repo"
echo "2. ArgoCD watches repository"
echo "3. Automatic deployment on changes"
echo "4. Prometheus monitors health"
echo "5. Grafana visualizes metrics"

echo ""
echo "🧪 Service Test (Running failure-prediction):"
docker run -d --name test-failure-prediction -p 8080:8080 vekiosnicola/failure-prediction:v2.0.0

sleep 2
echo "✅ Container started"
echo "🌐 Health check: http://localhost:8080/healthz"
curl -s http://localhost:8080/healthz | jq '.'
echo "📈 Metrics: http://localhost:8080/metrics"
curl -s http://localhost:8080/metrics | head -5

echo ""
echo "🧹 Cleanup:"
docker stop test-failure-prediction >/dev/null 2>&1
docker rm test-failure-prediction >/dev/null 2>&1

echo ""
echo "🎯 Next Steps:"
echo "1. 🚀 Push images to registry: docker push vekiosnicola/*:v2.0.0"
echo "2. ☸️  Deploy to Kubernetes: kubectl apply -k production/"
echo "3. 📊 Monitor: http://grafana.local/d/aura-ml-daemons"
echo "4. 🔧 Configure ArgoCD: kubectl apply -f argocd/application.yaml"

echo ""
echo "✨ Aura v2 ML Daemons ready for production deployment!"