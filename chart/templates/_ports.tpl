{{- define "ports.entries" -}}
{{- if .port }}
- containerPort: {{ .port }}
{{- end }}
{{- if .portMap }}
{{- range $portKey, $port := .portMap }}
- containerPort: {{ $port.internal }}
  name: {{ $portKey }}
{{- end }}
{{- end }}
{{- end -}}
