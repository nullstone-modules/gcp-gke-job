locals {
  main_container_name = "main"
  command             = length(var.command) > 0 ? var.command : null
}

// For GKE Tasks, we are going to create a job definition and emit via outputs
// Users of this app module (e.g. `nullstone exec`) can use this job definition as a template and customize to liking
// For instance, an execution may override CMD or add environment variables.
locals {
  pod_volumes = [
    for name, v in local.volumes : {
      name = name
      volumeSource = {
        persistentVolumeClaim = v.persistent_volume_claim
        emptyDir              = v.empty_dir
      }
    }
  ]
  pod_volume_mounts = [for name, vm in local.volume_mounts : {
    name             = name
    mountPath        = vm.mount_path
    subPath          = vm.sub_path
    mountPropagation = vm.mount_propagation
    readOnly         = vm.read_only
  }]
  pod_env_vars = [
    for k, v in local.all_env_vars : {
      name  = k
      value = v
    }
  ]
  pod_secrets = [
    for k in local.secret_keys : {
      name = k
      valueFrom = {
        secretKeyRef = {
          name = "${local.resource_name}-gsm-secrets"
          key  = env.value
        }
      }
    }
  ]

  job_definition = jsonencode({
    metadata = {
      namespace = local.kubernetes_namespace
      name      = "" // auto-generated by broker for each deploy
      labels    = local.app_labels
    }
    spec = {
      completions             = 1            // we only want to run 1 job
      backoffLimit            = 0            // do not retry builder jobs
      ttlSecondsAfterFinished = 24 * 60 * 60 // retain completed jobs for 1 day

      template = {
        metadata = {}
        spec = {
          restartPolicy = "Never"
          volumes       = local.pod_volumes

          containers = [
            {
              name         = local.main_container_name
              image        = "${local.service_image}:${local.app_version}"
              args         = local.command
              env          = concat(local.pod_env_vars, local.pod_secrets)
              volumeMounts = local.pod_volume_mounts
            }
          ]
        }
      }
    }
  })
}

// The following is used as reference to building a Kubernetes Job
// If you're using an IDE with Terraform auto-complete, uncomment to iterate on the contents
// Creating a job here doesn't help because we just want the template
/*
resource "kubernetes_job_v1" "this" {
  metadata {
    namespace = local.kubernetes_namespace
    name      = "" // auto-generated by broker before execution
    labels    = local.app_labels
  }

  spec {
    template {
      spec {
        restart_policy       = "Never"
        service_account_name = kubernetes_service_account_v1.app.metadata[0].name

        dynamic "volume" {
          for_each = local.volumes

          content {
            name = volume.key

            dynamic "empty_dir" {
              for_each = volume.value.empty_dir == null ? [] : [1]
              content {}
            }

            dynamic "persistent_volume_claim" {
              for_each = volume.value.persistent_volume_claim == null ? [] : [1]
              iterator = pvc

              content {
                claim_name = volume.value.persistent_volume_claim.claim_name
                read_only  = lookup(volume.value.persistent_volume_claim, "read_only", null)
              }
            }
          }
        }

        container {
          name  = local.main_container_name
          image = "${local.service_image}:${local.app_version}"
          args  = local.command

          resources {
            requests = {
              cpu    = var.cpu
              memory = var.memory
            }

            limits = {
              cpu    = var.cpu
              memory = var.memory
            }
          }

          dynamic "env" {
            for_each = local.all_env_vars

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env" {
            for_each = local.secret_keys

            content {
              name = env.value

              value_from {
                secret_key_ref {
                  name = "${local.resource_name}-gsm-secrets"
                  key  = env.value
                }
              }
            }
          }

          dynamic "volume_mount" {
            for_each = local.volume_mounts

            content {
              name              = volume_mount.key
              mount_path        = volume_mount.value.mount_path
              sub_path          = volume_mount.value.sub_path
              mount_propagation = volume_mount.value.mount_propagation
              read_only         = volume_mount.value.read_only
            }
          }
        }
      }
    }
  }
}
*/
