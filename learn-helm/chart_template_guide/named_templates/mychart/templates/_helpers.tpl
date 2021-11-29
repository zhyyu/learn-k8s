{{/* Generate basic labels */}}
{{- define "mychart.labels" }}
  labels:
    generator: helm
    date: {{ now | htmlDate }}
    chart: {{ .Chart.Name }}
{{- end }}

{{- define "mychart.tpl2" }}
app_name: {{ .Chart.Name }}
app_version: {{ .Chart.Version }}
{{- end }}
