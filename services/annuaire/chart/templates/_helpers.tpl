{{/*
  Helpers communs au chart annuaire.
*/}}

{{- define "annuaire.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "annuaire.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "annuaire.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Labels complets — les 4 obligatoires du polycopié.
*/}}
{{- define "annuaire.labels" -}}
app.kubernetes.io/name: {{ include "annuaire.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/part-of: devhub-campus
app.kubernetes.io/managed-by: Helm
{{- end -}}

{{/*
  Sélecteur stable : uniquement name + instance.
  On exclut managed-by car il peut changer entre Helm et ArgoCD.
*/}}
{{- define "annuaire.selectorLabels" -}}
app.kubernetes.io/name: {{ include "annuaire.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
