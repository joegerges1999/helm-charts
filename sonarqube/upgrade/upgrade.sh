#!/bin/sh

team=$1
app_version=$2
upgrade_to=$3
cluster_id=$4
project_id=$5

echo "Fetching metadata ..."
HOSTNAME=$(kubectl get --all-namespaces ingress -l app=sonarqube,team=$team -o jsonpath="{.items[0].spec.rules[0].host}")
WEBCONTEXT=$(kubectl get --all-namespaces ingress -l app=sonarqube,team=$team -o jsonpath="{.items[0].spec.rules[0].http.paths[0].path}")
POD=$(kubectl get pod --all-namespaces -l app=sonarqube,team=$team -o jsonpath="{.items[0].metadata.name}")
current_version=$(kubectl get --all-namespaces deployment -l app=sonarqube,team=$tean -o jsonpath="{.items[0].spec.template.spec.containers[1].image}")
current_version=$(cut -d ":" -f2 <<< "$current_version")

echo "Logging in to rancher ..."
rancher login https://rancher.cd.murex.com/ --token token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r --context $cluster_id:$project_id

echo "Removing ingress ..."
rancher app upgrade --values myvals.yaml $team-sonarqube 0.1.0 --set ingress.enabled='false' --set sonarqube.image.tag="$current_version"

echo "Backing up database ..."
kubectl -n sonarqube exec $POD -c sonardb -- bash -c "pg_dump -U sonar sonar > /var/lib/postgresql/data/sonar-backup.sql"

echo "Waiting for 5 seconds..."
sleep 5s

echo "Deploying the upgrade ..."
rancher app upgrade --values myvals.yaml $team-sonarqube 0.1.0 --set ingress.enabled='true' --set sonarqube.image.tag="$upgrade_to"

echo "Initiating playbook ..."
ansible-playbook upgrade.yaml --extra-vars "web_context=$WEBCONTEXT hostname=$HOSTNAME"
