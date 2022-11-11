{{- define "secretVolumeMount" }}
  {{- if not .Values.environment.isProd }}
- name: {{ .Release.Name }}-db-password
  mountPath: /secrets
  readOnly: true
  {{- end }}
{{- end }}

{{- define "secretVolume" }}
  {{- if not .Values.environment.isProd }}
- name: {{ .Release.Name }}-db-password
  secret:
    secretName: {{ .Release.Name }}-db-secret
    optional: false
  {{- end }}
{{- end }}

{{- define "secretsServiceAccount" }}
  {{- if .Values.environment.isProd }}
serviceAccountName: {{ .Release.Name }}-sa
  {{- end }}
{{- end }}


{{- define "vaultAnnotations" }}
  {{- if .Values.environment.isProd }}
annotations:
  vault.hashicorp.com/agent-inject: "true"
  vault.hashicorp.com/agent-inject-secret-database_password: "secret/database"
  vault.hashicorp.com/agent-inject-template-database_password: |
    {{ printf "{{- with secret \"secret/database\" -}}" }}
    {{ printf "{{ .Data.data.POSTGRES_PASSWORD }}" }}
    {{ printf "{{- end }}" }}
  vault.hashicorp.com/secret-volume-path-database_password: /secrets
  vault.hashicorp.com/role: use-cases
  {{- end }}
{{- end }}
