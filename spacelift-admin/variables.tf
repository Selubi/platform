variable "opentofu_version" {
  description = "OpenTofu version to use"
  type        = string
  default     = "1.10"
}

variable "terraform_workflow_tool" {
  description = "Specifies which flavor of tf"
  type        = string
  default     = "OPEN_TOFU"
}
