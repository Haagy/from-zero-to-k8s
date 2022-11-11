{{- define "dbInitScript" }}
  {{- if .Values.environment.isProd }}
CREATE DATABASE {{ .Values.db.name }};
\set password `cat /secrets/database_password`
CREATE USER {{ .Values.db.user }} WITH ENCRYPTED PASSWORD :'password';
GRANT ALL PRIVILEGES ON DATABASE {{ .Values.db.name }} TO {{ .Values.db.user }};
  {{- else }}
CREATE DATABASE {{ .Values.db.name }};
CREATE USER {{ .Values.db.user }} WITH ENCRYPTED PASSWORD {{ .Values.db.password | squote }};
GRANT ALL PRIVILEGES ON DATABASE {{ .Values.db.name }} TO {{ .Values.db.user }};
  {{- end }}
{{- end }}