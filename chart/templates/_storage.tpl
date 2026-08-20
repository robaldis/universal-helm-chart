{{- define "storage.volumeMounts" -}}
{{- if .storage }}
{{- range $storageName, $storage := .storage }}
- name: {{ $storageName }}
  mountPath: {{ $storage.path }}
  {{- if and (eq ($storage.type | default "pvc") "hostPath") $storage.readOnly }}
  readOnly: {{ $storage.readOnly }}
  {{- end }}
{{- end }}
{{- end }}
{{- if .files }}
{{- range $file := .files }}
- name: {{ $file.configName }}
  mountPath: {{ $file.mountPath }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "storage.volumes" -}}
{{- if .storage }}
{{- range $storageName, $storage := .storage }}
{{- $volumeType := $storage.type | default "pvc" }}
- name: {{ $storageName }}
  {{- if eq $volumeType "hostPath" }}
  hostPath:
    path: {{ $storage.hostPath }}
    {{- if $storage.hostPathType }}
    type: {{ $storage.hostPathType }}
    {{- end }}
  {{- end }}
  
  {{- if eq $volumeType "empty" }}
  emptyDir:
    {{- if $storage.capacity }}
    sizeLimit: {{ $storage.capacity }}
    {{- end }}
  {{- end }}

    {{- if eq $volumeType "secret" }}
  secret:
    secretName: {{ $storage.secret }}
    {{- end }}

  {{- if eq $volumeType "pvc" }}
  persistentVolumeClaim:
    claimName: {{ $storageName }}-pvc
  {{- end }}
{{- end }}
{{- end }}
{{- if .files }}
{{- range $file := .files }}
- name: {{ $file.configName }}
  configMap:
    name: {{ $file.configName }}
{{- end }}
{{- end }}
{{- end -}}
