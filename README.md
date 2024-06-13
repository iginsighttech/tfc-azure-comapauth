# Vault Backed Dynamic Credentials for Azure

Vault backed dynamic credentials uses OIDC connectors between the TFC workspace and Vault.

This repo can be used to bootstrap the trusted connections and set up the TFC workspace, Vault, and Azure.

The repo is based on examples from HashiCorp here - <https://github.com/hashicorp/terraform-dynamic-credentials-setup-examples/tree/main/vault-backed/aws>

The Terraform in this folder should be referenced as a module to set up dynamic credentials for a project and workspace.

Once the apply is successful connect the new terraform workspace to the desired version control system repo with VCS workflow for automatic runs.