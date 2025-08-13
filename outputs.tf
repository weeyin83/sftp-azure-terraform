output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

output "sftp_host" {
  description = "SFTP host you will connect to"
  value       = "${azurerm_storage_account.sa.name}.blob.core.windows.net"
}

output "sftp_username" {
  description = "Format: <storage_account>.<container>.<local_user>"
  value       = "${azurerm_storage_account.sa.name}.${azurerm_storage_container.container.name}.${azurerm_storage_account_local_user.sftp_user.name}"
}

output "sftp_password" {
  description = "Password for SFTP authentication"
  value       = azurerm_storage_account_local_user.sftp_user.password
  sensitive   = true
}
