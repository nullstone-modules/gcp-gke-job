data "ns_app_env" "this" {
  stack_id = data.ns_workspace.this.stack_id
  app_id   = data.ns_workspace.this.block_id
  env_id   = data.ns_workspace.this.env_id
}

locals {
  app_namespace  = local.kubernetes_namespace
  app_name       = data.ns_workspace.this.block_name
  app_version    = coalesce(data.ns_app_env.this.version, "latest")
  app_commit_sha = data.ns_app_env.this.commit_sha
}

locals {
  app_metadata = tomap({
    // Inject app metadata into capabilities here (e.g. service_account_id)
    service_account_id       = google_service_account.app.id
    service_account_email    = google_service_account.app.email
    service_name             = local.service_name
    job_definition_namespace = local.kubernetes_namespace
    job_definition_name      = local.job_definition_name
    // Shared external-secrets SecretStore in the app's namespace. Capabilities can
    // reference this to create ExternalSecrets without standing up their own store.
    // Reading the name through the resource attribute (instead of local.app_secret_store_name)
    // makes capabilities wait on the SecretStore being applied before their ExternalSecrets run.
    secret_store_name = kubernetes_manifest.gsm_secret_store.manifest.metadata.name
  })
}
