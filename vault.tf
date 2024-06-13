# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


# Enables the jwt auth backend in Vault at the given path,
# and tells it where to find TFC's OIDC metadata endpoints.
#
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend
resource "vault_jwt_auth_backend" "tfc_jwt" {
  path               = var.jwt_backend_path
  type               = "jwt"
  oidc_discovery_url = "https://${var.tfc_hostname}"
  bound_issuer       = "https://${var.tfc_hostname}"
}

# Creates a role for the jwt auth backend and uses bound claims
# to ensure that only the specified Terraform Cloud workspace will
# be able to authenticate to Vault using this role.
#
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role
resource "vault_jwt_auth_backend_role" "tfc_role" {
  backend        = vault_jwt_auth_backend.tfc_jwt.path
  role_name      = "tfc-role"
  token_policies = [vault_policy.tfc_policy.name]

  bound_audiences   = [var.tfc_vault_audience]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${var.tfc_workspace_name}:run_phase:*"
  }
  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 1200
}

# Creates a policy that will control the Vault permissions
# available to your Terraform Cloud workspace. Note that
# tokens must be able to renew and revoke themselves.
#
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "tfc_policy" {
  name = "tfc-policy"

  policy = <<EOT
# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}

# Allow Access to Azure Secrets Engine
path "azure/creds/${var.azure_secret_backend_role_name}" {
  capabilities = [ "read" ]
}

# Allow Access to all KV for the Namespace
path "tfc-kv/data/*" {
  capabilities = [ "read" ]
}
EOT
}


# Creates an Azure Secret Backend for Vault. The Azure secrets engine dynamically generates Azure service 
# principals and role assignments. Vault roles can be mapped to one or more Azure roles, providing a simple, 
# flexible way to manage the permissions granted to generated service principals.
#
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/azure_secret_backend
resource "vault_azure_secret_backend" "azure_secret_backend" {
  use_microsoft_graph_api = true
  subscription_id         = var.azure_subscription_id
  tenant_id               = var.azure_tenant_id

  # WARNING - These values will be written in plaintext in the statefiles for this configuration. Protect the statefiles for this configuration accordingly!
  client_secret = var.azure_client_secret
  client_id     = var.azure_client_id

}

# Creates an Azure Secret Backend Role for Vault. The Azure secrets engine dynamically generates Azure service
# principals and role assignments. Vault roles can be mapped to one or more Azure roles, providing a simple, 
# flexible way to manage the permissions granted to generated service principals.
#
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/azure_secret_backend_role
resource "vault_azure_secret_backend_role" "azure_secret_backend_role" {
  backend = vault_azure_secret_backend.azure_secret_backend.path
  role    = var.azure_secret_backend_role_name
  ttl     = "1h"
  max_ttl = "2h"

  azure_roles {
    role_name = "Contributor"
    scope     = "/subscriptions/${var.azure_subscription_id}/resourceGroups/${var.azure_resource_group_name}"
  }

  azure_roles {
    role_name = "Contributor"
    scope     = "/subscriptions/${var.azure_subscription_id}/resourceGroups/packerimages"
  }
}