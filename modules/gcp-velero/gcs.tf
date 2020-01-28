resource "google_storage_bucket" "main" {
  name          = "${var.backup_bucket_name}"
  location      = "EU"
  storage_class = "MULTI_REGIONAL"
}
