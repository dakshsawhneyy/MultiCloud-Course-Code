variable "project_name" {
  description = "Name of the SaaS project"
  type        = string
  default     = "enterprise-multicloud-saas"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}
