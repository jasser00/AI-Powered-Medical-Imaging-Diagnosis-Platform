module "acm" {
  source = "terraform-aws-modules/acm/aws"

  domain_name = "mydmain.com"
  zone_id     = "Z266PL4W4W6MSG"

  validation_method = "DNS"

  wait_for_validation = true
  tags                = local.common
}
output "acm_arn" {
  value = module.acm.acm_certificate_arn
}
