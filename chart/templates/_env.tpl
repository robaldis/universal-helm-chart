{{- define "env.vars" -}}
{{- if .env }}
{{- range $env_key, $env_value := .env }}
- name: {{ $env_key }}
  value: {{ $env_value | quote }}
{{- end }}
{{- end }}
{{- if .secretEnv }}
{{- range $env_key, $env_value := .secretEnv }}
- name: {{ $env_key }}
  valueFrom:
    secretKeyRef:
      name: {{ $env_value.name }}
      key: {{ $env_value.key }}
{{- end }}
{{- end }}
{{- end -}}
