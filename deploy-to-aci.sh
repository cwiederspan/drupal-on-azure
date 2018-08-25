#!/bin/bash

# Kick off a starter message
echo "Starting job..."

# Set the variables for creating the resources
NAME="my-drupal-container"
LOCATION="WESTUS2"

# Create the Resource Group
echo "Creating AKS cluster $NAME in $LOCATION..."
az group create --name $NAME --location $LOCATION

# Create the ACI container
az container create --name $NAME --resource-group $NAME --location $LOCATION --image drupal:latest --ports 80 443 --ip-address Public --dns-name-label $NAME