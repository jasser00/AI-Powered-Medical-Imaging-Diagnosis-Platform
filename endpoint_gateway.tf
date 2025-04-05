resource "aws_vpc_endpoint" "s3" {
  depends_on        = [module.test_vpc]
  vpc_id            = module.test_vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = module.test_vpc.private_route_table_ids
  tags              = local.common
}
resource "aws_route" "nat_gateway_route" {
  route_table_id         = module.test_vpc.private_route_table_ids[0]
  nat_gateway_id         = module.test_vpc.natgw_ids[0]
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    module.test_vpc,
    aws_vpc_endpoint.s3,
  ]
}
