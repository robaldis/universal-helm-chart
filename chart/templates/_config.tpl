{{- define "config.args" -}}
args: {{ toJson .args }}
{{- end -}}

{{- define "config.security" -}}
securityContext:
  privileged: true
{{- end -}}
