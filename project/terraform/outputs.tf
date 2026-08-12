output "eks_cluster_endpoint" {
  description = "EKS control plane endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "postgres_endpoint" {
  description = "RDS PostgreSQL endpoint"
  value       = module.rds.db_instance_endpoint
}

output "postgres_master_secret_arn" {
  description = "Secrets Manager ARN for RDS master credentials"
  value       = module.rds.db_instance_master_user_secret_arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}