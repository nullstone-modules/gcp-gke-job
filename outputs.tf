output "image_repo_url" {
  value       = data.google_container_registry_image.this.image_url
  description = "string ||| Service container image url."
}

output "log_provider" {
  value       = "gcp"
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
    email       = try(google_service_account.image_pusher.email, "")
    private_key = try(google_service_account_key.image_pusher.private_key, "")
  }

  description = "object({ email: string, private_key: string }) ||| A GCP service account that is allowed to push images."

  sensitive = true
}

output "deployer" {
  value = {
    email       = try(google_service_account.deployer.email, "")
    private_key = try(google_service_account_key.deployer.private_key, "")
  }

  description = "object({ email: string, private_key: string }) ||| A GCP service account with explicit privilege to deploy this GKE service to its cluster."
  sensitive   = true
}


output "main_container_name" {
  value       = local.main_container_name
  description = "string ||| The name of the container definition for the primary container"
}

output "job_definition" {
  value       = local.job_definition
  description = "string ||| A base64-encoded JSON string that provides a template for submitting a Job to Kubernetes."
}
