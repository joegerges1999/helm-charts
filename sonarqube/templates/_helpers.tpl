{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "SonarQube.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "SonarQube.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "SonarQube.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "SonarQube.labels" -}}
helm.sh/chart: {{ include "SonarQube.chart" . }}
{{ include "SonarQube.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "SonarQube.selectorLabels" -}}
app.kubernetes.io/name: {{ include "SonarQube.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "SonarQube.web.context" -}}
{{- .Values.sonarqube.webcontext }}
{{- end }}

{{- define "SonarQube.service.port" -}}
{{- .Values.service.port }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "SonarQube.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "SonarQube.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
