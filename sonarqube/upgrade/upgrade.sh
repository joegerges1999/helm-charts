#!/bin/sh

team=$1
upgrade_to=$2
cluster_id=c-jpxcn
project_id=p-zwxgj

echo "Fetching metadata ..."
HOSTNAME=$(kubectl get --all-namespaces ingress -l app=sonarqube,team=$team -o jsonpath="{.items[0].spec.rules[0].host}")
WEBCONTEXT=$(kubectl get --all-namespaces ingress -l app=sonarqube,team=$team -o jsonpath="{.items[0].spec.rules[0].http.paths[0].path}")
POD=$(kubectl get pod --all-namespaces -l app=sonarqube,team=$team -o jsonpath="{.items[0].metadata.name}")
current_version=$(kubectl get --all-namespaces deployment -l app=sonarqube,team=$team -o jsonpath="{.items[0].spec.template.spec.containers[1].image}")
current_version=$(cut -d ":" -f2 <<< "$current_version")

echo "Logging in to rancher ..."
rancher login https://rancher.cd.murex.com/ --token token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r --context $cluster_id:$project_id
app_version=$(rancher app | grep $team-sonarqube | awk '{print $6}')

echo "Removing ingress ..."
rancher app upgrade --values myvals.yaml $team-sonarqube $app_version --set ingress.enabled='false' --set sonarqube.image.tag="$current_version"

echo "Backing up database ..."
kubectl -n sonarqube exec $POD -c sonardb -- bash -c "pg_dump -U sonar sonar > /var/lib/postgresql/data/sonar-backup.sql"

echo "Waiting for 5 seconds..."
sleep 5s

echo "Deploying the upgrade ..."
rancher app upgrade --values myvals.yaml $team-sonarqube $app_version --set ingress.enabled='true' --set sonarqube.image.tag="$upgrade_to"

echo "Initiating playbook ..."
ansible-playbook upgrade.yaml --extra-vars "web_context=$WEBCONTEXT hostname=$HOSTNAME"
