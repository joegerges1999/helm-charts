#!/bin/sh

team=$1
upgrade_to=$2
web_context=$3
hostname=$4
app_version=$5

#removing ingress rules
../../rancher app upgrade --values myvals.yaml --set ingress.enabled='false' $team-sonarqube $app_version
#helm upgrade $team-sonarqube .. -f myvals.yaml --set ingress.enabled='false'

#exec in container and create dup

#scale down to 0 to avoid conflicts and add ingress rules again
../../rancher app upgrade --values myvals.yaml --set ingress.enabled='false' --set replicaCount='0' --set sonarqube.image.tag=$upgrade_to $team-sonarqube $app_version
#helm upgrade $team-sonarqube .. -f myvals.yaml --set replicaCount='0',ingress.enabled='false',sonarqube.image.tag="$upgrade_to"

#scale back up and enable ingress
../../rancher app upgrade --values myvals.yaml --set ingress.enabled='true' --set replicaCount='1' --set sonarqube.image.tag=$upgrade_to $team-sonarqube $app_version
#helm upgrade $team-sonarqube .. -f myvals.yaml --set replicaCount='1',ingress.enabled='true',sonarqube.image.tag="$upgrade_to"

#call playbook that checks if the service is up and calls the upgrade api as soon as it is up
ansible-playbook upgrade.yaml --extra-vars "web_context=$web_context hostname=$hostname"