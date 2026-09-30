# 0.4.0 (Sep 30, 2026)
* Upgraded `nullstone-io/ns` provider to `~> 0.13.0`.
* Replaced `ns_env_variables` and `ns_secret_keys` with the layered `ns_env_layout`, `ns_env_values`, and `ns_env_platform_data` data sources to aggregate environment variables and secrets.
* Emitted the `env` platform data record, including the source of each variable and the Kubernetes secret key of each managed secret.
* Upgraded capability scaffolding to emit `capability` on capability outputs and `cap_prefixes`.

# 0.3.0 (Jul 25, 2026)
* Added support for structured env var references: `{{ k8s.field(...) }}`, `{{ k8s.configMap(...) }}`, `{{ k8s.resourceField(...) }}`, and `{{ k8s.fileKey(...) }}`. Previously these were silently dropped — only plain values and `{{ secret(...) }}` were rendered. They are now emitted in both the job definition template (`nullstone exec`) and cron jobs. `fileKey` requires Kubernetes 1.34+ with the `EnvFiles` feature gate.

# 0.2.0 (Jun 19, 2026)
* Upgraded `nullstone-io/ns` provider to `~> 0.11.0`.
* Used `gcp_labels` from `data.ns_workspace` to label resources.
* Used `k8s_labels` from `data.ns_workspace` for Kubernetes resource labels.

# 0.1.6 (Jun 10, 2026)
* Fixed nullstone provider upgrade.

# 0.1.5 (Jun 10, 2026)
* Upgraded terraform providers.
* Added support for env variables in cron jobs.

# 0.1.4 (Jun 08, 2026)
* Added `GOOGLE_CLOUD_REGION` env var to app.

# 0.1.3 (May 1, 2026)
* Wired up `var.cpu` and `var.memory`.
* Added `var.max_cpu` and `var.max_memory`.

# 0.1.2 (May 1, 2026)
* Added `project_id` to outputs.

# 0.1.1 (May 1, 2026)
* Upgraded nullstone provider.
* Ensured consistent ordering of `OTEL_RESOURCE_ATTRIBUTES` env var to reduce diffs.

# 0.1.0 (Apr 30, 2026)
* Initial draft
