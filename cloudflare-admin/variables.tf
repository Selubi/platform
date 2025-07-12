variable "spacelift_stack_terraform_version" {
  description = "OpenTofu version to use"
  type        = string
  default     = "1.1"
}

variable "spacelift_stack_terraform_workflow_tool" {
  description = "Specifies which flavor of tf"
  type        = string
  default     = "OPEN_TOFU"
}
