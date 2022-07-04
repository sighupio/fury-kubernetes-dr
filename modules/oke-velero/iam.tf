/**
 * Copyright (c) 2022 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "oci_identity_user" "velero" {
  compartment_id = var.tenancy_ocid
  description    = "This user is created and managed by Terraform"
  name           = "${var.backup_bucket_name}-velero"

  freeform_tags = var.tags
}

resource "oci_identity_group" "velero" {
  compartment_id = var.tenancy_ocid
  description    = "This group is created and managed by Terraform"
  name           = "${var.backup_bucket_name}-velero"

  freeform_tags = var.tags
}

resource "oci_identity_user_group_membership" "velero" {
  group_id = oci_identity_group.velero.id
  user_id  = oci_identity_user.velero.id
}

resource "oci_identity_customer_secret_key" "velero" {
  display_name = "velero"
  user_id      = oci_identity_user.velero.id
}

resource "oci_identity_policy" "velero" {
  #Required
  compartment_id = var.tenancy_ocid
  description    = "This policy is created and managed by terraform"
  name           = "${var.backup_bucket_name}-velero"

  statements = [
    "Allow group ${oci_identity_group.velero.name} to read buckets in compartment id ${var.backup_compartment_id}",
    "Allow group ${oci_identity_group.velero.name} to manage objects in compartment id ${var.backup_compartment_id} where all {target.bucket.name = '${var.backup_bucket_name}'}",
  ]

  #Optional
  freeform_tags = var.tags
}


