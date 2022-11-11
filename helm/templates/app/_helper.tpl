{{- define "appVolumeMounts" -}}
  {{- if not .Values.environment.isProd }}
volumeMounts:
    {{- include "secretVolumeMount" . | indent 2 }}
  {{- else }}
volumeMounts: []
  {{- end }}
{{- end }}


{{- define "appVolumes" -}}
  {{- if not .Values.environment.isProd }}
volumes:
    {{- include "secretVolume" . | indent 2 }}
  {{- else }}
volumes: []
  {{- end }}
{{- end }}


