# platform
Managing my cloud resources with IaC.

OpenTofu backend is using spacelift.
Spacelift itself is managed by opentofu spacelift provider with an administrative stack on the `spacelift-admin` folder.
(See [managing Spacelift with Spacelift](https://docs.spacelift.io/vendors/terraform/terraform-provider))