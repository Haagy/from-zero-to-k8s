{{- define "dbInitScript" }}
  {{- if .Values.secrets.vault.enabled }}
CREATE DATABASE {{ .Values.db.name }};
\set content `cat /secrets/POSTGRES_PASSWORD`
CREATE USER {{ .Values.db.user }} WITH ENCRYPTED PASSWORD :'content';
GRANT ALL PRIVILEGES ON DATABASE {{ .Values.db.name }} TO {{ .Values.db.user }};
  {{- else }}
CREATE DATABASE {{ .Values.db.name }};
CREATE USER {{ .Values.db.user }} WITH ENCRYPTED PASSWORD {{ .Values.db.password | squote }};
GRANT ALL PRIVILEGES ON DATABASE {{ .Values.db.name }} TO {{ .Values.db.user }};
  {{- end }}
{{- end }}