terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "1.25.0"
    }
  }
}

provider "spacelift" {}


######################################
# Stacks
######################################

# This is the root stack that manages Spacelift itself.
# It lives in the "root" space and creates other spaces and admin stacks.
resource "spacelift_stack" "spacelift_admin" {
  space_id                         = "root"
  name                             = "spacelift-admin"
  description                      = "Stack to manage Spacelift itself"
  branch                           = "main"
  repository                       = "platform"
  project_root                     = "spacelift-admin"
  terraform_version                = var.spacelift_stack_terraform_version
  terraform_workflow_tool          = var.spacelift_stack_terraform_workflow_tool
  autodeploy                       = true
  administrative                   = true
  terraform_smart_sanitization     = true
  enable_well_known_secret_masking = true
  protect_from_deletion            = true
  labels = ["folder:component/platform"]
}


resource "spacelift_stack" "cloudflare_admin" {
  space_id                         = "root"
  name                             = "cloudflare-admin"
  description                      = "Stack to create additional cloudflare stacks and tokens"
  branch                           = "main"
  repository                       = "platform"
  project_root                     = "cloudflare-admin"
  terraform_version                = var.spacelift_stack_terraform_version
  terraform_workflow_tool          = var.spacelift_stack_terraform_workflow_tool
  autodeploy                       = true
  terraform_smart_sanitization     = true
  enable_well_known_secret_masking = true
  administrative = true  # To manage and grant tokens to other cloudflare stacks
  labels = ["folder:component/platform"]
}

#######################################
# config.tfvars mounting
#######################################

resource "spacelift_context" "platform_config_vars" {
  name        = "platform-config-vars"
  description = "Configuration variables and settings for all platform stacks."
  labels = ["folder:component/platform"] # Optional: labels for organization
}

resource "spacelift_mounted_file" "platform_config_tfvars_mounted" {
  context_id = spacelift_context.platform_config_vars.id
  # This path means the file will be at /mnt/workspace/config.tfvars
  relative_path = "config.tfvars"
  content = file("${path.module}/../config.tfvars") # This reads your file from your Git repo
  write_only    = false
}

resource "spacelift_environment_variable" "platform_tf_var_files_env_var" {
  context_id = spacelift_context.platform_config_vars.id
  name       = "TF_VAR_FILES"
  # This path instructs Terraform to go up from the project_root
  # (e.g., from /mnt/workspace/source/my-repo/spacelift-admin/)
  # to find the file at /mnt/workspace/source/my-repo/platform-common.tfvars
  value      = "/mnt/workspace/config.tfvars"
  write_only = false
}


resource "spacelift_context_attachment" "cloudflare_admin_config_attachment" {
  context_id = spacelift_context.platform_config_vars.id
  stack_id   = spacelift_stack.cloudflare_admin.id
}

resource "spacelift_context_attachment" "spacelift_admin_config_attachment" {
  context_id = spacelift_context.platform_config_vars.id
  stack_id   = spacelift_stack.spacelift_admin.id
}


#######################################
# Manual contexts
#######################################


# cloudflare-admin-context is manually created
resource "spacelift_context_attachment" "cloudflare_admin_context_attachment" {
  context_id = "cloudflare-admin-context"
  stack_id   = spacelift_stack.cloudflare_admin.id
}
