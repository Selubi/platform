variable "spacelift_stack_terraform_version" {
  description = "OpenTofu version to use"
  type        = string
  default     = "1.10"
}

variable "spacelift_stack_terraform_workflow_tool" {
  description = "Specifies which flavor of tf"
  type        = string
  default     = "OPEN_TOFU"
}

variable "spacelift_stack_additional_project_globs" {
  description = "Additional project globs that, if changed, should trigger a Spacelift run for the stack."
  type = set(string) # Defines it as a set of strings
  default = ["config.tfvars"] # Provides the desired default value
}