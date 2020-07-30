replicaCount: 1

team: jgerges

hostname: "istestkubmaster1.fr.murex.com"

imagePullPolicy: Always

imagePullSecrets: "docker-all"

dockerRegistry: "docker-all.nexus.murex.com/"

cappedRequests:
  enabled: false
  requests:
    cpu: 2000m
    memory: 4096Mi
  limits:
    cpu: 2000m
    memory: 4096Mi

sonarqube:
  proxy:
    enabled: false
  http:
    proxyHost: ""
    proxyPort: ""
  https:
    proxyHost: ""
    proxyPort: ""
  image:
    name: "sonarqube"
    tag: "7.9.3-community"
  port: 9000
  webcontext: "sonar"

db:
  image:
    name: postgres
    tag: latest
  port: 5432
  name: sonar
  credentials:
    secret: "pg-credentials"
    usernameKey: "username"
    passwordKey: "password"

env:
#  - name: env-name-1
#    value: env-value-1
#  - name: env-name-2
#    value: env-value-2

disablePlugins: true

regex:
  - version: "8.3.*|8.4.*"
    pattern: .*/sonar-\(auth-github\|auth-gitlab\|ldap\|auth-saml\|cnes\|ha\|branch\|developer\|license\|python\).*jar
  - version: "8.1.*|8.2.*"
    pattern: .*/sonar-\(auth-github\|auth-gitlab\|ldap\|auth-saml\|ha\|branch\|developer\|license\|python\).*jar
  - version: "7.9.*"
    pattern: .*/sonar-\(ha\|branch\|developer\|license\|python\).*jar

pvc:
  enabled: true
  sqDataName: data
  sqLogsName: logs
  sqConfName: conf
  sqExtensionsName: extensions
  pgName: current
  pgDataName: data

persistance:
  enabled: true
  accessMode: ReadWriteMany
  dbStorage: 5Gi
  dbDataStorage: 5Gi
  sqDataStorage: 5Gi
  sqConfStorage: 5Gi
  sqExtensionsStorage: 20Gi
  sqLogsStorage: 5Gi

ingress:
  enabled: true

service:
  enabled: true
  port: 9000
  type: LoadBalancer

deployment:
  enabled: true

probes:
  enabled: true
  livenessProbe:
    initialDelaySeconds: 60
    periodsSeconds: 30
  readinessProbe:
    initialDelaySeconds: 60
    periodSeconds: 30
    failureThreshold: 6
    
  
