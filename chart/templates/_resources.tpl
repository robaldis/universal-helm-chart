{{- define "resources.spec" -}}
resources:
  requests:
    cpu: {{ .requests.cpu | default "100m" | quote }}
    memory: {{ .requests.memory | default "100Mi" | quote }}
  limits:
    cpu: {{ .limits.cpu | default "100m" | quote }}
    memory: {{ .limits.memory | default "100Mi" | quote }}
{{- end -}}
