provider "aws" {
  region  = "${var.region}"
  version = "~> 2.47"
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
  name               = "${var.my_cluster_name}"
  env                = "${var.environment}"
  backup_bucket_name = "${var.my_cluster_name}-${var.environment}-velero"
  region             = "${var.region}"
}

output "cloud_credentials" {
  value     = "${module.velero.cloud_credentials}"
  sensitive = true
}

output "backup_storage_location" {
  value     = "${module.velero.backup_storage_location}"
  sensitive = true
}

output "volume_snapshot_location" {
  value     = "${module.velero.volume_snapshot_location}"
  sensitive = true
}
