terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.25.0"
    }
  }
}

provider "spacelift" {}


# This is the root stack that manages Spacelift itself.
# It lives in the "root" space and creates other spaces and admin stacks.
resource "spacelift_stack" "spacelift_admin" {
  space_id                         = "root"
  name                             = "spacelift-admin"
  description                      = "Stack to manage Spacelift itself"
  branch                           = "main"
  repository                       = "platform"
  project_root                     = "spacelift-admin"
  terraform_version                = var.opentofu_version
  autodeploy                       = true
  administrative                   = true
  terraform_smart_sanitization     = true
  enable_well_known_secret_masking = true
  protect_from_deletion            = true
  labels                           = ["folder:component/platform"]
}



resource "spacelift_stack" "cloudflare_token_factory" {
  space_id                         = "root"
  name                             = "cloudflare-token-factory"
  description                      = "Stack to create additional cloudflare tokens"
  branch                           = "main"
  repository                       = "platform"
  project_root                     = "cloudflare-token-factory"
  terraform_version                = var.opentofu_version
  administrative                   = true # To register created tokens as spacelift contexts
  autodeploy                       = true
  terraform_smart_sanitization     = true
  enable_well_known_secret_masking = true
  protect_from_deletion            = true
  labels                           = ["folder:component/platform"]
}

# cloudflare-token-factory-context is manually created
resource "spacelift_context_attachment" "cloudflare_token_factor_context_attachment" {
  context_id = "cloudflare-token-factory-context"
  stack_id   = spacelift_stack.cloudflare_token_factory.id
}
