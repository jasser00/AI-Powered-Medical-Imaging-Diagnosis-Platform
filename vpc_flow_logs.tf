module "vpc_flow_logs" {
  source  = "umotif-public/vpc-flow-logs/aws"
  version = "~> 1.1.0"

  name_prefix = "ai-vpc-flow"
  vpc_id      = module.test_vpc.vpc_id

  traffic_type = "ALL"

  tags = local.common
}
output "vpc_flow_logs_id" {
  value = module.vpc_flow_logs.vpc_flow_logs_id
}
output "vpc_cloudwatch_log_group_arn" {
  value = module.vpc_flow_logs.vpc_flow_logs_cloudwatch_group_arn
}
