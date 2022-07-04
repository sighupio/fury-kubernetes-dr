/**
 * Copyright (c) 2022 SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */
resource "oci_objectstorage_bucket" "velero" {
  compartment_id = var.backup_compartment_id
  name           = var.backup_bucket_name
  namespace      = var.object-storage-namespace

  freeform_tags = var.tags
}

