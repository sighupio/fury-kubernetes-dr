variable cluster_name {}
variable environment {}

variable aws_region {
  default = "eu-west-1"
}

variable ark_backup_bucket_name {}

provider aws {
  region = "eu-west-1"
}
