#!/bin/bash

# Aura v2 ML Daemons - Build & Deploy Script
set -e

echo "🚀 Building Aura v2 ML Daemons..."

# Configuration
REGISTRY="aura-ecosystem"
VERSION="v2.0.0"
NAMESPACE="aura-ecosystem"

# Build Docker images
build_images() {
    echo "📦 Building Docker images..."
    
    docker build -f dockerfiles/failure-prediction.Dockerfile -t ${REGISTRY}/failure-prediction:${VERSION} .
    docker build -f dockerfiles/auto-scaling-ml.Dockerfile -t ${REGISTRY}/auto-scaling-ml:${VERSION} .
    docker build -f dockerfiles/inference-routing.Dockerfile -t ${REGISTRY}/inference-routing-optimizer:${VERSION} .
    
    echo "✅ Images built successfully"
}

# Push to registry
push_images() {
    echo "📤 Pushing images to registry..."
    
    docker push ${REGISTRY}/failure-prediction:${VERSION}
    docker push ${REGISTRY}/auto-scaling-ml:${VERSION}
    docker push ${REGISTRY}/inference-routing-optimizer:${VERSION}
    
    echo "✅ Images pushed successfully"
}

# Deploy to Kubernetes
deploy_to_k8s() {
    echo "🚀 Deploying to Kubernetes..."
    
    # Create namespace
    kubectl apply -f base/namespace.yaml
    
    # Deploy using kustomize
    kubectl apply -k production/
    
    echo "✅ Deployment initiated"
}

# Wait for deployment
wait_for_deployment() {
    echo "⏳ Waiting for deployment to be ready..."
    
    kubectl wait --for=condition=available --timeout=300s deployment/failure-prediction-daemon -n ${NAMESPACE}
    kubectl wait --for=condition=available --timeout=300s deployment/auto-scaling-ml-daemon -n ${NAMESPACE}
    kubectl wait --for=condition=available --timeout=300s deployment/inference-routing-optimizer -n ${NAMESPACE}
    
    echo "✅ All deployments ready"
}

# Show status
show_status() {
    echo "📊 Deployment Status:"
    kubectl get pods -n ${NAMESPACE}
    kubectl get services -n ${NAMESPACE}
    kubectl get hpa -n ${NAMESPACE}
}

# Main execution
main() {
    case "${1:-all}" in
        "build")
            build_images
            ;;
        "push")
            push_images
            ;;
        "deploy")
            deploy_to_k8s
            ;;
        "wait")
            wait_for_deployment
            ;;
        "status")
            show_status
            ;;
        "all")
            build_images
            push_images
            deploy_to_k8s
            wait_for_deployment
            show_status
            ;;
        *)
            echo "Usage: $0 {build|push|deploy|wait|status|all}"
            exit 1
            ;;
    esac
}

main "$@"