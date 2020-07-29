#!/bin/sh

#removing ingress rules
helm upgrade sonarqube . --set ingress.enabled='false',sonarqube.webcontext='sonar',sonarqube.image.tag='7.9.3-community',hostname='jgerges',dockerRegistry='',imagePullSecrets=''

#exec in container and create dup

#scale down to 0 to avoid conflicts and add ingress rules again
helm upgrade sonarqube . --set replicaCount='0',sonarqube.webcontext='sonar',sonarqube.image.tag='8.4.1-community',hostname='jgerges',dockerRegistry='',imagePullSecrets=''

#scale back up
helm upgrade sonarqube . --set sonarqube.webcontext='sonar',sonarqube.image.tag='8.4.1-community',hostname='jgerges',dockerRegistry='',imagePullSecrets=''

#call playbook that checks if the service is up and calls the upgrade api as soon as it is up
