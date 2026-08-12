variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "dev"
}

variable "hcp_terraform_org" {
  description = "HCP Terraform organization identifier (documented in tfvars; cloud block org is configured in terraform.tf)"
  type        = string
  default     = "default"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.33"
}

variable "name" {
  description = "Base name for all resources"
  type        = string
  default     = "go-microservices"
}

variable "node_instance_type" {
  description = "EKS managed node group instance type"
  type        = string
  default     = "t3.medium"
}

variable "postgres_engine_version" {
  description = "PostgreSQL engine version for RDS"
  type        = string
  default     = "16.4"
}

variable "postgres_major_engine_version" {
  description = "PostgreSQL major version for option groups"
  type        = string
  default     = "16"
}

variable "postgres_parameter_family" {
  description = "DB parameter group family for PostgreSQL"
  type        = string
  default     = "postgres16"
}

variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}