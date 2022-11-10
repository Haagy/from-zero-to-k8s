{{- define "secretsPath" }}
  {{- if .Values.secrets.vault.enabled }}
vault
  {{ else }}
secrets
  {{- end }}
{{- end }}

{{- define "secretVolumeMount" }}
- name: db-password
  mountPath: {{ .Values.secrets.path }}
  readOnly: true
{{- end }}

{{- define "secretVolume" }}
- name: db-password
  secret:
    secretName: {{ .Release.Name }}-db-secret
    optional: false
{{- end }}

{{- define "secretsServiceAccount" }}
  {{- if .Values.secrets.vault.enabled }}
serviceAccountName: {{ .Release.Name }}-sa
  {{- end }}
{{- end }}


{{- define "appAnnotations" }}
  {{- if .Values.secrets.vault.enabled }}
annotations:
  vault.hashicorp.com/agent-inject: "true"
  vault.hashicorp.com/agent-inject-secret-database: "secret/database"
  vault.hashicorp.com/agent-inject-template-POSTGRES_PASSWORD: |
    {{ printf "{{- with secret \"secret/database\" -}}" }}
    {{ printf "{{ .Data.data.password }}" }}
    {{ printf "{{- end }}" }}
  vault.hashicorp.com/secret-volume-path-POSTGRES_PASSWORD: {{ include "secretsPath" }}
  vault.hashicorp.com/role: {{ .Release.Name | quote }}
  {{- end }}
{{- end }}
