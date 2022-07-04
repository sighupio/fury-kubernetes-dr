/**
 * Copyright (c) 2022 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

variable "backup_bucket_name" {
  type        = string
  description = "Backup Bucket Name"
}

variable "backup_compartment_id" {
  type        = string
  description = "Compartment OCID where the bucket is"
}

variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID"
}

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to resources"
  default     = {}
}

variable "region" {
  type        = string
  description = "OCI Region"
}

variable "object-storage-namespace" {
  type        = string
  description = "Object storage namespace"
}
