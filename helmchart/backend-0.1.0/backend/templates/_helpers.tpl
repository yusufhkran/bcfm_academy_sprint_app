
{{- /* Backend fullname */ -}}
{{- define "backend.fullname" -}}
{{- printf "%s-%s" .Release.Name "backend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /* Frontend fullname */ -}}
{{- define "frontend.fullname" -}}
{{- printf "%s-%s" .Release.Name "frontend" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /* Backend name (no release name prefix) */ -}}
{{- define "backend.name" -}}
backend
{{- end -}}

{{- /* Frontend name (no release name prefix) */ -}}
{{- define "frontend.name" -}}
frontend
{{- end -}}
