/**
 * Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

variable "oidc_provider_url" {
  type        = string
  description = "URL of OIDC issuer discovery document"
  default     = ""
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

data "aws_caller_identity" "current" {}
