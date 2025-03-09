#!/bin/bash

# This script sets up a Kubernetes cluster for model serving with enhanced checks, optimizations, colored output, and progress bars.

set -euo pipefail

# Load configuration
source ./cluster_config.sh

# --- Color definitions ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# --- Functions ---

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error_exit() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

success() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] SUCCESS: $1${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}" | tee -a "$LOG_FILE"
}

progress_bar() {
    local duration=$1
    local steps=$2
    local message=$3
    local step_duration=$(echo "scale=2; $duration / $steps" | bc)

    echo -ne "${message} ["
    for ((i=0; i<steps; i++)); do
        echo -ne "${GREEN}#${NC}"
        sleep $step_duration
        echo -ne "\b#"  # Overwrite the previous character
    done
    echo -e "] Done!"
}

check_dependencies() {
    local deps=("terraform" "kubectl" "helm" "gcloud")
    for dep in "${deps[@]}"; do
        command -v "$dep" >/dev/null 2>&1 || error_exit "$dep is required but not installed."
    done
    success "All dependencies are installed."
}

# --- 1. Set up the Cluster ---
setup_cluster() {
    local cluster_name=$(get_value GCP_CONFIG_KEYS[@] GCP_CONFIG_VALUES[@] CLUSTER_NAME)
    local zone=$(get_value GCP_CONFIG_KEYS[@] GCP_CONFIG_VALUES[@] ZONE)
    local project=$(get_value GCP_CONFIG_KEYS[@] GCP_CONFIG_VALUES[@] PROJECT)

    log "Checking if cluster already exists..."
    if gcloud container clusters describe "$cluster_name" --zone "$zone" --project "$project" >/dev/null 2>&1; then
        warning "Cluster $cluster_name already exists. Skipping Terraform and cluster creation."
    else
        log "Cluster $cluster_name does not exist. Creating it now..." 
        run_terraform
        progress_bar 120 40 "Applying Terraform changes"
    fi

    login_gke
    check_cluster_health
}

run_terraform() {
    pushd "$TERRAFORM_DIR" >/dev/null || error_exit "Failed to change directory to $TERRAFORM_DIR"
    log "Initializing Terraform..."
    terraform init || error_exit "Terraform initialization failed"
    log "Planning Terraform changes..."
    terraform plan || error_exit "Terraform plan failed"
    log "Applying Terraform changes..."
    terraform apply -auto-approve || error_exit "Terraform apply failed"
    popd >/dev/null || error_exit "Failed to return from $TERRAFORM_DIR"
    success "Terraform operations completed successfully."
}

login_gke() {
    local cluster_name=$(get_value GCP_CONFIG_KEYS[@] GCP_CONFIG_VALUES[@] CLUSTER_NAME)
    local zone=$(get_value GCP_CONFIG_KEYS[@] GCP_CONFIG_VALUES[@] ZONE)
    local project=$(get_value GCP_CONFIG_KEYS[@] GCP_CONFIG_VALUES[@] PROJECT)

    log "Logging into GKE cluster..."
    gcloud container clusters get-credentials "$cluster_name" \
        --zone "$zone" \
        --project "$project" \
        || error_exit "Failed to get GKE credentials"
    success "Successfully logged into GKE cluster."
}

# --- Helper Functions ---
check_cluster_health() {
    log "Checking cluster health..."
    kubectl get nodes && kubectl get pods --all-namespaces && kubectl get services --all-namespaces || \
        error_exit "Failed to check cluster health"
    success "Cluster health check passed."
}

# --- 2. Deploy Nginx Ingress Controller ---
deploy_nginx_ingress() {
    local nginx_namespace=$(get_value NAMESPACE_KEYS[@] NAMESPACE_VALUES[@] NGINX)
    local nginx_chart=$(get_value CHART_KEYS[@] CHART_VALUES[@] NGINX_INGRESS)

    ensure_namespace_exists "$nginx_namespace"

    log "Installing NGINX Ingress using Helm..."
    helm upgrade --install nginx-ingress "$nginx_chart" --namespace "$nginx_namespace" || \
        error_exit "Failed to install NGINX Ingress"

    wait_for_pods "$nginx_namespace" "app.kubernetes.io/name=nginx-ingress"
    success "NGINX Ingress installed successfully."

    wait_for_external_ip
}

# --- Helper Functions ---
ensure_namespace_exists() {
    local namespace=$1
    log "Ensuring namespace $namespace exists..."
    kubectl get namespace "$namespace" >/dev/null 2>&1 || \
        kubectl create namespace "$namespace" || error_exit "Failed to create namespace: $namespace"
    success "Namespace $namespace exists or was created."
}

wait_for_pods() {
    local namespace=$1
    local label=$2
    local timeout=${3:-300}
    log "Waiting for pods with label $label in namespace $namespace to be ready..."
    kubectl wait --for=condition=ready pod -l "$label" -n "$namespace" --timeout="${timeout}s" || \
        error_exit "Pods did not become ready within ${timeout} seconds"
    success "Pods are ready."
}

wait_for_external_ip() {
    local max_retries=60
    local sleep_time=10
    local attempt=1
    local nginx_namespace=$(get_value NAMESPACE_KEYS[@] NAMESPACE_VALUES[@] NGINX)

    log "Waiting for the NGINX Ingress Controller to expose an external IP..."

    while [ $attempt -le $max_retries ]; do
        local external_ip=$(kubectl get svc nginx-ingress-controller -n "$nginx_namespace" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

        if [ -n "$external_ip" ]; then
            success "External IP for NGINX Ingress Controller: $external_ip"
            export EXTERNAL_IP=$external_ip
            return 0
        fi

        progress_bar $sleep_time 10 "Waiting for external IP (Attempt $attempt of $max_retries)"
        ((attempt++))
    done

    error_exit "Failed to retrieve the external IP for the NGINX Ingress Controller after $max_retries attempts."
}

# --- Main ---

main() {
    log "Starting cluster setup..."

    check_dependencies
    setup_cluster
    deploy_nginx_ingress

    success "Cluster setup complete!"
}

# Set up trap to catch errors
trap 'error_exit "An error occurred. Exiting..."' ERR

main "$@"