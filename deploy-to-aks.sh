#!/bin/bash

# Kick off a starter message
echo "Starting job..."

# Set the variables for creating the resources
resource_group="my-drupal-cluster-rg"
name="my-drupal-cluster"
location="westus2"

# Create the Resource Group
echo "Creating AKS cluster $name in $location..."
az group create --name $resource_group --location $location

# Create an AKS cluster
az aks create --resource-group $resource_group --name $name --location $location --node-count 1 --node-vm-size Standard_DS2_v2 --dns-name-prefix $name --generate-ssh-keys --enable-addons http_application_routing --kubernetes-version 1.11.1

# Get the credentials and wire them up to kubectl
az aks get-credentials -n $name -g $resource_group

# Create a service account for wiring RBAC up to Helm
kubectl create -f helm-rbac.yaml

# Install Helm with the tiller service account
helm init --service-account tiller

# Sleep for a short amount of time to let Helm/Tiller finish installing
sleep 30s

# Install Drupal using Helm
helm install stable/drupal --name drupal --namespace drupal01