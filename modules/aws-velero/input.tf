/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

variable "backup_bucket_name" {
  type        = string
  description = "Backup Bucket Name"
}

variable "tags" {
  type        = map(string)
  description = "Custom tags to apply to resources"
  default     = {}
}

variable "oidc_provider_url" {
  type        = string
  description = "URL of OIDC issuer discovery document"
  default     = ""
}

data "aws_caller_identity" "current" {}
