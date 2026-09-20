{{- define "mcp-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mcp-server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "mcp-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "mcp-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mcp-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "mcp-server.labels" -}}
helm.sh/chart: {{ include "mcp-server.chart" . }}
{{ include "mcp-server.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* image.tag is "1.2.3" or "@sha256:...". */}}
{{- define "mcp-server.image" -}}
{{- $tag := required "image.tag is required: a tag or a digest, never latest" .Values.image.tag -}}
{{- if eq $tag "latest" }}{{ fail "image.tag must not be latest: what was reviewed is what runs" }}{{ end -}}
{{- $repository := required "image.repository is required" .Values.image.repository -}}
{{- if hasPrefix "@" $tag }}{{ printf "%s%s" $repository $tag }}{{ else }}{{ printf "%s:%s" $repository $tag }}{{ end -}}
{{- end }}
