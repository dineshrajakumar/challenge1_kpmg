variable "resource_group_name" {
  description = "Name of the resource group to be created"
  type = "string"
  default = ""
  }

variable "location" {
  description = "The Azure location to deploy resources to."
  default     = "UKWEST"
  }

variable "avs_name" {
  description = "Name of avs"
  type = "string"
  default = ""
  }

variable "account_tier" {
  description = "Account"
  default     = "Standard"
  }

variable "account_replication_type" {
  description = "Account replication type"
  default     = "GRS"
  }  

variable "tags" {
  description = "Map of tags to be attached to the resource group"
  #type        = map
  default     = { "los" = "XXX", "id" = "1234"}
  }
