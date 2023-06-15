/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

terraform {
  backend "s3" {
    skip_region_validation = true
  }

  required_version = "~> 1.4"
  required_providers {
    aws = "~> 3.76.1"
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  default = "eu-west-1"
}

variable "my_cluster_name" {}
variable "environment" {
  default = "testing"
}

module "velero" {
  source             = "../../modules/aws-velero"
  backup_bucket_name = "${var.my_cluster_name}-${var.environment}-velero-e2e"
}

output "cloud_credentials" {
  value     = module.velero.cloud_credentials
  sensitive = true
}

output "backup_storage_location" {
  value     = module.velero.backup_storage_location
  sensitive = true
}

output "volume_snapshot_location" {
  value     = module.velero.volume_snapshot_location
  sensitive = true
}
