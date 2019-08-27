resource "google_storage_bucket" "main" {
  name          = "velero-${var.name}-${var.env}"
  location      = "EU"
  storage_class = "MULTI_REGIONAL"
}
