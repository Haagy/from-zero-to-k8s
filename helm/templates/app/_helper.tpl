{{- define "appVolumeMounts" -}}
  {{- if not .Values.secrets.vault.enabled }}
volumeMounts:
    {{ include "secretVolumeMount" . | indent 2 }}
  {{- else }}
volumeMounts: {}
  {{- end }}
{{- end }}


{{- define "appVolumes" -}}
  {{- if not .Values.secrets.vault.enabled }}
volumes:
    {{ include "secretVolume" . | indent 2 }}
  {{- else }}
volumes: {}
  {{- end }}
{{- end }}


