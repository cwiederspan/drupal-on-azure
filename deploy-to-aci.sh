#!/bin/bash

# Kick off a starter message
echo "Starting job..."

# Set the variables for creating the resources
name="my-drupal-container"
location="westus2"

# Override any of the hard-coded variable names with command line params
while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        value=$(echo "${1/--/}"|sed "s/-/_/")
        declare $value="$2"
    fi
    shift
done

# Create the Resource Group
echo "Creating ACI container $name in $location..."
az group create --name $name --location $location

# Create the ACI container
az container create --name $name --resource-group $name --location $location --image drupal:latest --ports 80 443 --ip-address Public --dns-name-label $name