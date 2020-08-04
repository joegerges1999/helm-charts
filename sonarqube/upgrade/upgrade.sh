#!/bin/sh

app_name=$1
app_version=$2
current_version=$3
upgrade_to=$4
hostname=$5
web_context=$6

terraform init

terraform apply -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "upgrade_version=$current_version" -var 'ingress_enabled=false' -var 'replica_count=1' -auto-approve

POD=$(kubectl get pod --all-namespaces -l app=sonarqube -o jsonpath="{.items[0].metadata.name}")

#removing ingress rules
rancher app upgrade --values myvals.yaml --set ingress.enabled='false' $team-sonarqube $app_version
#helm upgrade $team-sonarqube .. -f myvals.yaml --set ingress.enabled='false'

#exec in container and create dup
POD=$(kubectl get pod --all-namespaces -l app=sonarqube -o jsonpath="{.items[0].metadata.name}")

#scale down to 0 to avoid conflicts and add ingress rules again
rancher app upgrade --values myvals.yaml --set ingress.enabled='false' --set replicaCount='0' --set sonarqube.image.tag=$upgrade_to $team-sonarqube $app_version
#helm upgrade $team-sonarqube .. -f myvals.yaml --set replicaCount='0',ingress.enabled='false',sonarqube.image.tag="$upgrade_to"

#scale back up and enable ingress
rancher app upgrade --values myvals.yaml --set ingress.enabled='true' --set replicaCount='1' --set sonarqube.image.tag=$upgrade_to $team-sonarqube $app_version
#helm upgrade $team-sonarqube .. -f myvals.yaml --set replicaCount='1',ingress.enabled='true',sonarqube.image.tag="$upgrade_to"

#call playbook that checks if the service is up and calls the upgrade api as soon as it is up
ansible-playbook upgrade.yaml --extra-vars "web_context=$web_context hostname=$hostname"