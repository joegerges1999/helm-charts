#!/bin/sh

team=$1
app_version=$2
current_version=$(kubectl get --all-namespaces deployment -l app=sonarqube -o jsonpath="{.items[0].spec.template.spec.containers[1].image}")
current_version=$(cut -d ":" -f2 <<< "$current_version")
upgrade_to=$3
cluster_id=$4
project_id=$5

# terraform init && \
# terraform import -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "sq_version=$current_version" -var 'ingress_enabled=true' -var 'replica_count=1' rancher2_app.rancher2 $cluster_id:$project_id:$team-sonarqube && \
# terraform apply -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "sq_version=$current_version" -var 'ingress_enabled=false' -var 'replica_count=1' -auto-approve && \
# POD=$(kubectl get pod --all-namespaces -l app=sonarqube,team=$team -o jsonpath="{.items[0].metadata.name}") && \
# kubectl -n sonarqube exec $POD -c sonardb -- bash -c "pg_dump -U sonar sonar > /var/lib/postgresql/data/sonar-backup.sql" && \
# terraform apply -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "sq_version=$upgrade_to" -var 'ingress_enabled=false' -var 'replica_count=0' -auto-approve && \
# terraform apply -var 'rancher2_token_key=token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r' -var "sq_version=$upgrade_to" -var 'ingress_enabled=true' -var 'replica_count=1' -auto-approve

rancher login https://rancher.cd.murex.com/ --token token-vkq9d:wg8gtt4gbgtk7nzfhlj4gs87dn4w2hxhd9qmcb9fmnqkllgx57792r --context $cluster_id:$project_id 
rancher app upgrade --values myvals.yaml $team-sonarqube 0.1.0 --set ingress.enabled='false' --set sonarqube.image.tag="$current_version" 
POD=$(kubectl get pod --all-namespaces -l app=sonarqube,team=$team -o jsonpath="{.items[0].metadata.name}")
kubectl -n sonarqube exec $POD -c sonardb -- bash -c "pg_dump -U sonar sonar > /var/lib/postgresql/data/sonar-backup.sql"
rancher app upgrade --values myvals.yaml $team-sonarqube 0.1.0 --set ingress.enabled='false' --set sonarqube.image.tag="$upgrade_to" --set replicaCount='0'
sleep 5s
rancher app upgrade --values myvals.yaml $team-sonarqube 0.1.0 --set ingress.enabled='true' --set sonarqube.image.tag="$upgrade_to" --set replicaCount='1'


HOST=$(kubectl get --all-namespaces ingress -l app=sonarqube -o jsonpath="{.items[0].spec.rules[0].host}")
PATH=$(kubectl get --all-namespaces ingress -l app=sonarqube -o jsonpath="{.items[0].spec.rules[0].http.paths[0].path}")
ansible-playbook upgrade.yaml --extra-vars "web_context=$PATH hostname=$HOST"