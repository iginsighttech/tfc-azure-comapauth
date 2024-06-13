# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Variables for Azure

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription ID"
  default = ""
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant ID"
  default = ""
}

variable "azure_client_id" {
  type        = string
  description = "Azure client ID (WARNING - Will be written to this configuration's state and plan files in plaintext)"
  sensitive   = true
  default     = ""
}

variable "azure_client_secret" {
  type        = string
  description = "Azure client secret (WARNING - Will be written to this configuration's state and plan files in plaintext)"
  sensitive   = true
  default     = ""
}

variable "azure_secret_backend_role_name" {
  type        = string
  description = "Name of Azure secret backend role you created for runs to use"
  default     = ""
}

variable "azure_resource_group_name" {
  type        = string
  description = "Name of the Azure resource group you wish to provision resources for"
  default     = ""
}

# Variables for TFE/TFC

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Vault"

}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
  default     = "InSightTechnologies"
}

variable "tfc_project_name" {
  type        = string
  description = "The project under which a workspace will be created"
  default     = "Admin Project"
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of the workspace that you'd like to create and connect to Azure"
  default     = ""
}

variable "tfc_token" {
  type        = string
  description = "Api token used to connect to TFC"
  default     = ""
}

variable "tfc_working_directory" {
  type        = string
  default     = "/"
  description = "directory in the VCS repo to watch"

}

variable "tfc_workspace_branch" {
  type        = string
  default     = "main"
  description = "Branch in VCS to trigger jobs from"
}

variable "tfc_repo_path" {
  type        = string
  description = "The path of the repo"
  default     = ""
}


# Variables for Vault

variable "vault_addr" {
  description = "the approle id established in prereq steps"
  type        = string
  default     = ""
}

variable "vault_token" {
  description = "the approle id established in prereq steps"
  type        = string
  default     = ""
}

variable "jwt_backend_path" {
  type        = string
  default     = "jwt"
  description = "The path at which you'd like to mount the jwt auth backend in Vault"
}

variable "vault_namespace" {
  type        = string
  description = "The namespace of the Vault instance you'd like to create the Azure and jwt auth backends in"
  default     = ""
}

variable "tfc_vault_audience" {
  type        = string
  default     = "vault.workload.identity"
  description = "The audience value to use in run identity tokens"
}