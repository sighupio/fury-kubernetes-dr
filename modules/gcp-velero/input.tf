variable "project" {
  description = "GCP Project where colocate the bucket"
  type        = "string"
}

variable "name" {
  type        = "string"
  description = "Cluster Name"
}
variable "env" {
  type        = "string"
  description = "Environment Name"
}
variable "backup_bucket_name" {
  type        = "string"
  description = "Backup Bucket Name"
}
