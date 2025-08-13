##
# Variables
##

##
# Common Variables
##
variable "tag_environment" {
  type    = string
  description = "The environment for the resources"
  default = "Testing"
}

variable "tag_project" {
  type    = string
  description = "The project for the resources"
  default = "SFTP"
}

variable "tag_creator" {
  type    = string
  description = "The creator for the resources"
  default = "TechieLass"
}

variable "location" {
  type    = string
  default = "UK South"
}

variable "container_name" {
  type    = string
  default = "sftp-root"
}

variable "sftp_local_user" {
  type    = string
  default = "extpartner1"
}

variable "account_replication_type" {
  type    = string
  description = "The replication type for the storage account, values can be LRS or ZRS."
  default = "LRS"
}
