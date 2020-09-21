variable "name" {
  type        = string
  description = "Cluster Name"
}

variable "env" {
  type        = string
  description = "Environment Name"
}

variable "oidc_provider_url" {
  type = string
  description = "URL of OIDC issuer discovery document"
  default = ""
}

variable "backup_bucket_name" {
  type        = string
  description = "Backup Bucket Name"
}

variable "region" {
  type        = string
  description = "AWS Region where colocate the bucket"
}

data "aws_caller_identity" "current" {}
