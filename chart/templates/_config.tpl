{{- define "config.args" -}}
args: {{ toJson .args }}
{{- end -}}

{{- define "ingress.host" -}}
{{- if .ingress.url -}}
{{- .ingress.url -}}
{{- else -}}
{{- .ingress.subdomain -}}.{{- .baseDomain -}}
{{- end -}}
{{- end -}}

{{- define "config.security" -}}
securityContext:
  privileged: true
{{- end -}}
