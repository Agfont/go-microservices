data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Project     = "go-microservices"
    Terraform   = "true"
    Environment = var.environment
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0"

  name = "${var.name}-vpc"
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name               = "${var.name}-eks"
  kubernetes_version = var.kubernetes_version
  subnet_ids         = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id

  endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      instance_types = [var.node_instance_type]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  tags = local.tags
}

resource "aws_security_group" "postgres" {
  name        = "${var.name}-postgres-sg"
  description = "Allow PostgreSQL from EKS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [module.eks.node_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "7.2.0"

  identifier = "${var.name}-postgres"

  engine               = "postgres"
  engine_version       = var.postgres_engine_version
  family               = var.postgres_parameter_family
  major_engine_version = var.postgres_major_engine_version
  instance_class       = var.db_instance_class

  allocated_storage           = 20
  db_name                     = "users"
  username                    = "postgres"
  manage_master_user_password = true
  port                        = "5432"

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets
  vpc_security_group_ids = [aws_security_group.postgres.id]

  backup_retention_period = 7
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = local.tags
}