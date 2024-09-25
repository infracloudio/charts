{{/*
Expand the name of the chart.
*/}}
{{- define "kf-notebooks.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kf-notebooks.fullname" -}}
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
Create a default name for notebook pvc.
*/}}

{{- define "kf-notebooks.notebooks.jupyter.pvc.name.base" -}}
{{- printf "%s-%s" (include "kf-notebooks.fullname" .) .Values.notebooks.jupyter.name | trunc 53 | trimSuffix "-" -}}
{{- end }}

{{- define "kf-notebooks.notebooks.vscode.pvc.name.base" -}}
{{- printf "%s-%s" (include "kf-notebooks.fullname" .) .Values.notebooks.vscode.name | trunc 53 | trimSuffix "-" -}}
{{- end }}

{{- define "kf-notebooks.notebooks.jupyter.pvc.name" -}}
{{- printf "%s-%s" (include "kf-notebooks.notebooks.jupyter.pvc.name.base" .) "workspace" -}}
{{- end }}

{{- define "kf-notebooks.notebooks.vscode.pvc.name" -}}
{{- printf "%s-%s" (include "kf-notebooks.notebooks.vscode.pvc.name.base" .) "workspace" -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kf-notebooks.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kf-notebooks.labels" -}}
helm.sh/chart: {{ include "kf-notebooks.chart" . }}
{{ include "kf-notebooks.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kf-notebooks.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kf-notebooks.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Check if Notebook CRD is installed
*/}}
{{- define "kf-notebooks.checkNotebookCRD" -}}
{{- if not (.Capabilities.APIVersions.Has "kubeflow.org/v1") -}}
{{- fail "Notebook CRD is not installed in the cluster. Please install Kubeflow first." -}}
{{- end -}}
{{- end -}}
