variable "rancher2_token_key" {
  type = string
  description = "The bearer token to login to rancher"
}

variable "sq_version" {
  type = string
  description = "The version we want to upgrade to"
}

variable "ingress_enabled" {
  type = bool
  description = "Enable and Disable ingess"
}

variable "replica_count" {
  type = string
  description = "replica count"
}

provider "rancher2" {
  api_url = "https://rancher.cd.murex.com"
  token_key = var.rancher2_token_key
}

resource "rancher2_app" "rancher2" {
  catalog_name = "c-jpxcn:sonar-is-dev-ops"
  name = "jgerges-sonarqube"
  project_id = "c-jpxcn:p-zwxgj"
  target_namespace = "sonarqube"
  template_name = "sonarqube"
  template_version = "0.1.0"
  values_yaml = "cmVwbGljYUNvdW50OiAxCgp0ZWFtOiBqZ2VyZ2VzCgpob3N0bmFtZTogImlzdGVzdGt1Ym1hc3RlcjEuZnIubXVyZXguY29tIgoKaW1hZ2VQdWxsUG9saWN5OiBBbHdheXMKCmltYWdlUHVsbFNlY3JldHM6ICJkb2NrZXItYWxsIgoKZG9ja2VyUmVnaXN0cnk6ICJkb2NrZXItYWxsLm5leHVzLm11cmV4LmNvbS8iCgpjYXBwZWRSZXF1ZXN0czoKICBlbmFibGVkOiBmYWxzZQogIHJlcXVlc3RzOgogICAgY3B1OiAyMDAwbQogICAgbWVtb3J5OiA0MDk2TWkKICBsaW1pdHM6CiAgICBjcHU6IDIwMDBtCiAgICBtZW1vcnk6IDQwOTZNaQoKc29uYXJxdWJlOgogIHByb3h5OgogICAgZW5hYmxlZDogZmFsc2UKICBodHRwOgogICAgcHJveHlIb3N0OiAiIgogICAgcHJveHlQb3J0OiAiIgogIGh0dHBzOgogICAgcHJveHlIb3N0OiAiIgogICAgcHJveHlQb3J0OiAiIgogIGltYWdlOgogICAgbmFtZTogInNvbmFycXViZSIKICAgIHRhZzogIjguNC4xLWNvbW11bml0eSIKICBwb3J0OiA5MDAwCiAgd2ViY29udGV4dDogInNvbmFyIgoKZGI6CiAgaW1hZ2U6CiAgICBuYW1lOiBwb3N0Z3JlcwogICAgdGFnOiBsYXRlc3QKICBwb3J0OiA1NDMyCiAgbmFtZTogc29uYXIKICBjcmVkZW50aWFsczoKICAgIHNlY3JldDogInBnLWNyZWRlbnRpYWxzIgogICAgdXNlcm5hbWVLZXk6ICJ1c2VybmFtZSIKICAgIHBhc3N3b3JkS2V5OiAicGFzc3dvcmQiCgplbnY6CiMgIC0gbmFtZTogZW52LW5hbWUtMQojICAgIHZhbHVlOiBlbnYtdmFsdWUtMQojICAtIG5hbWU6IGVudi1uYW1lLTIKIyAgICB2YWx1ZTogZW52LXZhbHVlLTIKCmRpc2FibGVQbHVnaW5zOiB0cnVlCgpyZWdleDoKICAtIHZlcnNpb246ICI4LjMuKnw4LjQuKiIKICAgIHBhdHRlcm46IC4qL3NvbmFyLVwoYXV0aC1naXRodWJcfGF1dGgtZ2l0bGFiXHxsZGFwXHxhdXRoLXNhbWxcfGNuZXNcfGhhXHxicmFuY2hcfGRldmVsb3Blclx8bGljZW5zZVx8cHl0aG9uXCkuKmphcgogIC0gdmVyc2lvbjogIjguMS4qfDguMi4qIgogICAgcGF0dGVybjogLiovc29uYXItXChhdXRoLWdpdGh1Ylx8YXV0aC1naXRsYWJcfGxkYXBcfGF1dGgtc2FtbFx8aGFcfGJyYW5jaFx8ZGV2ZWxvcGVyXHxsaWNlbnNlXHxweXRob25cKS4qamFyCiAgLSB2ZXJzaW9uOiAiNy45LioiCiAgICBwYXR0ZXJuOiAuKi9zb25hci1cKGhhXHxicmFuY2hcfGRldmVsb3Blclx8bGljZW5zZVx8cHl0aG9uXCkuKmphcgoKcHZjOgogIGVuYWJsZWQ6IHRydWUKICBzcURhdGFOYW1lOiBkYXRhCiAgc3FMb2dzTmFtZTogbG9ncwogIHNxQ29uZk5hbWU6IGNvbmYKICBzcUV4dGVuc2lvbnNOYW1lOiBleHRlbnNpb25zCiAgcGdOYW1lOiBjdXJyZW50CiAgcGdEYXRhTmFtZTogZGF0YQoKcGVyc2lzdGFuY2U6CiAgZW5hYmxlZDogdHJ1ZQogIGFjY2Vzc01vZGU6IFJlYWRXcml0ZU1hbnkKICBkYlN0b3JhZ2U6IDVHaQogIGRiRGF0YVN0b3JhZ2U6IDVHaQogIHNxRGF0YVN0b3JhZ2U6IDVHaQogIHNxQ29uZlN0b3JhZ2U6IDVHaQogIHNxRXh0ZW5zaW9uc1N0b3JhZ2U6IDIwR2kKICBzcUxvZ3NTdG9yYWdlOiA1R2kKCmluZ3Jlc3M6CiAgZW5hYmxlZDogdHJ1ZQoKc2VydmljZToKICBlbmFibGVkOiB0cnVlCiAgcG9ydDogOTAwMAogIHR5cGU6IExvYWRCYWxhbmNlcgoKZGVwbG95bWVudDoKICBlbmFibGVkOiB0cnVlCgpwcm9iZXM6CiAgZW5hYmxlZDogdHJ1ZQogIGxpdmVuZXNzUHJvYmU6CiAgICBpbml0aWFsRGVsYXlTZWNvbmRzOiA2MAogICAgcGVyaW9kc1NlY29uZHM6IDMwCiAgcmVhZGluZXNzUHJvYmU6CiAgICBpbml0aWFsRGVsYXlTZWNvbmRzOiA2MAogICAgcGVyaW9kU2Vjb25kczogMzAKICAgIGZhaWx1cmVUaHJlc2hvbGQ6IDYKICAgIAogIAo="
  answers = {
      "sonarqube.image.tag" = var.sq_version
      "ingress.enabled" = var.ingress_enabled
      "replicaCount" = var.replica_count
  }
}