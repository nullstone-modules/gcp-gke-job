output "image_repo_url" {
  value       = module.scaffold.repository_url
  description = "string ||| Service container image url."
}

output "log_provider" {
  value       = "gke"
  description = "string ||| The log provider used for this service."
}

output "log_reader" {
  value       = module.scaffold.log_reader
  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to read logs for this application."
}

output "service_name" {
  value       = "" // Always blank because we don't create a Kubernetes Service for tasks
  description = "string ||| The name of the kubernetes deployment for the app."
}

output "service_namespace" {
  value       = local.app_namespace
  description = "string ||| The kubernetes namespace where the app resides."
}

output "service_account_email" {
  value       = module.scaffold.app_service_account.email
  description = "string ||| Email of the GCP service account attached to this app"
}

output "image_pusher" {
  value       = module.scaffold.image_pusher
  description = "object({ email: string, impersonate: bool }) ||| A GCP service account that is allowed to push images."
}

output "deployer" {
  value       = module.scaffold.deployer
  description = "object({ email: string, impersonate: bool }) ||| A GCP service account with explicit privilege to deploy this GKE service to its cluster."
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
