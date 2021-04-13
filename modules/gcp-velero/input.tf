/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

variable "project" {
  description = "GCP Project where colocate the bucket"
  type        = string
}

variable "backup_bucket_name" {
  type        = string
  description = "Backup Bucket Name"
}

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to resources"
  default     = {}
}

variable "google_service_account_name" {
  type        = string
  description = "Name of the gcp service account to create for velero"
  default     = "velero-sa"
}

variable "workload_identity" {
  type        = bool
  description = "Flag to specify if velero should use workload identity instead of credentials"
  default     = true
}

variable "workload_identity_kubernetes_service_account" {
  type        = string
  description = "Name of the service account in kubernetes that will use the workload identity"
  default     = "velero-sa"
}
