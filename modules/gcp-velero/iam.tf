resource "google_service_account" "velero" {
  project      = "${var.project}"
  account_id   = "${var.name}-${var.env}-velero"
  display_name = "Velero account for ${var.name} at ${var.env}"
}

resource "google_service_account_key" "velero" {
  service_account_id = "${google_service_account.velero.name}"
}