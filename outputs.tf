output "image_repo_url" {
  value       = local.repository_url
  description = "string ||| Service container image url."
}

output "log_provider" {
  value       = "gke"
  description = "string ||| The log provider used for this service."
}

output "service_name" {
  value       = "" // Always blank because we don't create a Kubernetes Service for tasks
  description = "string ||| The name of the kubernetes deployment for the app."
}

output "service_namespace" {
  value       = local.app_namespace
  description = "string ||| The kubernetes namespace where the app resides."
}

output "image_pusher" {
  value = {
    project_id  = local.project_id
    email       = try(google_service_account.image_pusher.email, "")
    impersonate = true
  }

  description = "object({ email: string, impersonate: bool }) ||| A GCP service account that is allowed to push images."

  sensitive = true
}

output "deployer" {
  value = {
    project_id  = local.project_id
    email       = try(google_service_account.deployer.email, "")
    impersonate = true
  }

  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to deploy this GKE service to its cluster."
  sensitive   = true
}

output "main_container_name" {
  value       = local.main_container_name
  description = "string ||| The name of the container definition for the primary container"
}

output "job_definition_name" {
  value       = local.job_definition_name
  description = "string ||| The name of the Kubernetes ConfigMap containing the Job template"
}

output "private_urls" {
  value       = local.private_urls
  description = "list(string) ||| A list of URLs only accessible inside the network"
}

output "public_urls" {
  value       = local.public_urls
  description = "list(string) ||| A list of URLs accessible to the public"
}
