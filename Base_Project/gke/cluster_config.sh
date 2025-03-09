#!/bin/bash

# cluster_config.sh
# Configuration file for Kubernetes cluster setup

# GCP Configuration
GCP_CONFIG_KEYS=("PROJECT" "ZONE" "CLUSTER_NAME")
GCP_CONFIG_VALUES=("online-boutique-449209" "asia-southeast1" "online-boutique-gke")

# Terraform Configuration
TERRAFORM_DIR="./terraform"

# Namespace Configuration
NAMESPACE_KEYS=("ONLINE_BOUTIQUE" "NGINX")
NAMESPACE_VALUES=("online-bputique" "nginx-system")

LOG_FILE="/tmp/cluster_setup.log"

# Chart Configuration
CHART_KEYS=("NGINX_INGRESS" "KONG")
CHART_VALUES=("./deployments/nginx-ingress" "./deployments/kong")

# Function to get value from array
get_value() {
    local keys=("${!1}")
    local values=("${!2}")
    local key=$3
    for i in "${!keys[@]}"; do
        if [[ "${keys[$i]}" == "$key" ]]; then
            echo "${values[$i]}"
            return
        fi
    done
    echo "Key not found: $key"
    return 1
}