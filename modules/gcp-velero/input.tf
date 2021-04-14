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

variable "gcp_service_account_name" {
  type        = string
  description = "Name of the gcp service account to create for velero"
  default     = "velero-sa"
}

variable "gcp_custom_role_name" {
  type        = string
  description = "Name of the gcp custom role to assign to the gcp service account"
  default     = "velero_role" 
}

variable "workload_identity" {
  type        = bool
  description = "Flag to specify if velero should use workload identity instead of credentials"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to resources"
  default     = {}
}
