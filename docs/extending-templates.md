# Extending Templates with Components

Workload templates (`deployment.yaml`, `daemonset.yaml`) share a lot of logic.
Instead of duplicating inline blocks, shared pieces are extracted into 
**component files** — `_*.tpl` files that define reusable named templates.

## How it works

Each `_*.tpl` file contains one or more `define` blocks. Workload templates use 
`{{ include }}` to pull them in.

```yaml
{{- define "componentName.templateName" -}}
... yaml snippet, unindented ...
{{- end -}}
```

Usage in a workload template:

```yaml
containers:
- name: app
  image: nginx
{{ include "componentName.templateName" $value | indent 8 }}
```

The `$value` passed as context becomes `.` inside the template, so fields like 
`.port`, `.env`, `.storage` resolve automatically.

## Existing components

| File | Templates | Purpose |
|---|---|---|
| `_storage.tpl` | `storage.volumeMounts`, `storage.volumes` | Volume mounts and volume definitions for pod specs |
| `_ports.tpl` | `ports.entries` | Container port entries from `.port` and `.portMap` |
| `_env.tpl` | `env.vars` | Environment variables from `.env` and `.secretEnv` |
| `_resources.tpl` | `resources.spec` | CPU/memory requests and limits with defaults |
| `_config.tpl` | `config.args`, `config.security` | Container command args and security context |

## Adding a new component

Say you want to extract liveness/readiness probes into a reusable template.

### 1. Identify the duplicated block

In `deployment.yaml` and `daemonset.yaml` you have:

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 5
```

### 2. Create or add to a `_*.tpl` file

```yaml
# _probes.tpl
{{- define "probes.liveness" -}}
{{- if .healthEndpoint }}
livenessProbe:
  httpGet:
    path: {{ .healthEndpoint }}
    port: {{ .port }}
  initialDelaySeconds: {{ .healthDelay | default 5 }}
{{- end }}
{{- end -}}
```

Naming conventions:
- File starts with `_` (Helm skips these when rendering Kubernetes resources)
- Template names use `component.action` format: `storage.volumeMounts`, `ports.entries`, etc.

### 3. Use it in workload templates

```yaml
containers:
- name: {{ $key | quote }}
  image: {{ $value.image }}:{{ $value.tag }}
{{ include "probes.liveness" $value | indent 8 }}
```

### 4. Verify

```bash
helm template . -f my-values.yaml
```

The rendered output should match the original inline version — just without the duplication.

## Indentation rules

Templates produce unindented YAML. The caller uses the `indent` filter to align it.

| Where template is included | Typical indent |
|---|---|
| Inside `containers:` (ports, env, resources) | `8` |
| Inside `containers:` — nested list items (env var entries) | `10` |
| Inside `spec:` (volumes) | `6` or `8` |

Check the surrounding indentation in the workload template by counting spaces 
from the left margin to where the generated YAML should appear.

## Context passing

`include "templateName" context` — the second argument is the template's `.`. 
In this chart, templates are called with `$value` (one entry from `.Values.deployments`).
This means template authors access fields as `.port`, `.env`, `.storage`, etc. directly.



