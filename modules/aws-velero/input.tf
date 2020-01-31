variable "name" {
  type        = string
  description = "Cluster Name"
}
variable "env" {
  type        = string
  description = "Environment Name"
}
variable "backup_bucket_name" {
  type        = string
  description = "Backup Bucket Name"
}
variable "region" {
  type        = string
  description = "AWS Region where colocate the bucket"
}
