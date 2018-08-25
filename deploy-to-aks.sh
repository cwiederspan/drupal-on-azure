#!/bin/bash

# Kick off a starter message
echo "Starting job..."

# Set the variables for creating the resources
CLUSTER_NAME="mlcr-aks-20180823"
CLUSTER_LOCATION="WESTUS2"

# Create the Resource Group
echo "Creating AKS cluster $CLUSTER_NAME in $CLUSTER_LOCATION..."
az group create --name $CLUSTER_NAME --location $CLUSTER_LOCATION

# Create an AKS cluster
az aks create --resource-group $CLUSTER_NAME --name $CLUSTER_NAME --location $CLUSTER_LOCATION --node-count 1 --node-vm-size Standard_DS2_v2 --dns-name-prefix $CLUSTER_NAME --generate-ssh-keys --enable-addons http_application_routing --kubernetes-version 1.11.1

# Get the credentials and wire them up to kubectl
az aks get-credentials -n $CLUSTER_NAME -g $CLUSTER_NAME

# Create a service account for wiring RBAC up to Helm
kubectl create -f helm-rbac.yaml

# Install Helm with the tiller service account
helm init --service-account tiller

# Sleep for a short amount of time to let Helm/Tiller finish installing
sleep 30s

# Install Drupal using Helm
helm install stable/drupal --name drupal --namespace drupal01