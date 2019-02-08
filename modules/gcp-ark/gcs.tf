resource "google_storage_bucket" "main" {
  name     = "velero-${var.mame}-${var.env}"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}