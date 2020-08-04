#!/bin/sh

app_name=$1
app_version=$2
current_version=$3
upgrade_to=$4
hostname=$5
web_context=$6

terraform init

#removing ingress for backup
terraform apply -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "upgrade_version=$current_version" -var 'ingress_enabled=false' -var 'replica_count=1' -auto-approve

#getting pod name
POD=$(kubectl get pod --all-namespaces -l app=sonarqube -o jsonpath="{.items[0].metadata.name}")

#backing up
kubectl -n sonarqube exec $POD -c sonardb -- bash -c "pg_dump -U sonar sonar > sonar-backup.sql"

#starting upgrade
terraform apply -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "upgrade_version=$upgrade_to" -var 'ingress_enabled=false' -var 'replica_count=0' -auto-approve

#enabling ingress
terraform apply -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "upgrade_version=$upgrade_to" -var 'ingress_enabled=true' -var 'replica_count=1' -auto-approve

ansible-playbook upgrade.yaml --extra-vars "web_context=$web_context hostname=$hostname"