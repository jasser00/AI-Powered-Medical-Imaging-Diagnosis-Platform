module "test_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "my-vpc-test"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  public_subnet_tags = {
    Name = "public-subnet"
  }
  private_subnet_tags = {
    Name = "private-subnet"
  }
  tags = local.common
}
output "vpc_id" {
  description = "this is the vpc_id"
  value       = module.test_vpc.vpc_id
}
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.test_vpc.private_subnets
}
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.test_vpc.public_subnets
}
output "private_routes" {
  description = "List of IDs of prviate routes"
  value       = module.test_vpc.private_route_table_ids
}
output "nat_gateway_id" {
  description = "List of IDs of nat gateways"
  value       = module.test_vpc.natgw_ids
}
