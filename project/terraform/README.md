# go-microservices AWS minimal Terraform

This root module provisions the minimum AWS foundation inferred from your current manifests:

- Kubernetes workloads in `project/k8s/*.yml`
- Gateway API host routing in `project/gateway.yml`
- PostgreSQL requirement from `project/postgres.yml`

## What this creates

- VPC with 2 public and 2 private subnets
- EKS cluster with 1 managed node group
- RDS PostgreSQL instance (`users` database)
- Security group rule allowing PostgreSQL access from EKS nodes

## Module versions resolved from Terraform Registry

- `hashicorp/aws` provider: `~> 6.38` (latest resolved: `6.38.0`)
- `terraform-aws-modules/vpc/aws`: `6.6.0`
- `terraform-aws-modules/eks/aws`: `21.15.1`
- `terraform-aws-modules/rds/aws`: `7.2.0`

## Notes for your current app

- Your current `authentication-service` DSN points to `host.minikube.internal`.
  Replace it with the `postgres_endpoint` output and retrieve credentials from
  `postgres_master_secret_arn`.
- Your Gateway routes use hosts `front-end.info` and `broker-service.info`.
  In AWS, you still need a Gateway API-compatible controller in EKS and DNS
  records that map these hostnames to the load balancer.

## Usage

```bash
terraform init
terraform fmt
terraform validate
terraform plan
```