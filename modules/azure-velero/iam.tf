resource "azuread_application" "main" {
  name = "${var.name}-${var.env}-velero"
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "random_string" "main" {
  length  = 36
  special = false

  keepers = {
    service_principal = azuread_service_principal.main.id
  }
}

resource "azuread_service_principal_password" "main" {
  service_principal_id = azuread_service_principal.main.id
  value                = random_string.main.result
  end_date             = timeadd(timestamp(), "8760h")

  # This stops be 'end_date' changing on each run and causing a new password to be set
  # to get the date to change here you would have to manually taint this resource...
  lifecycle {
    ignore_changes = [end_date]
  }
}

resource "azurerm_role_assignment" "aks" {
  scope                = data.azurerm_resource_group.aks.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.main.id
}

resource "azurerm_role_assignment" "snapshot" {
  scope                = data.azurerm_resource_group.velero.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.main.id
}

resource "azurerm_role_assignment" "velero" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.main.id
}
