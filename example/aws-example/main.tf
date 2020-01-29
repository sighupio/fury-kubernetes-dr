provider "aws" {
  region = "${var.region}"
}

variable "region" {
  default = "eu-west-1"
}

module "velero" {
  source             = "../../modules/aws-velero"
  cluster_name       = "e2e-testing"
  environment        = "testing"
  backup_bucket_name = "sighup-e2e-testing-velero"
  aws_region         = "${var.region}"
}

output "cloud_credentials" {
  value = "${module.velero.cloud_credentials}"
}

output "backup_storage_location" {
  value = "${module.velero.backup_storage_location}"
}

output "volume_snapshot_location" {
  value = "${module.velero.volume_snapshot_location}"
}
