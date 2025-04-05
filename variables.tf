variable "aws_region" {
  default     = "us-east-1"
  description = "this is the region for aws"
  type        = string
}
variable "instance_type" {
  default = "t2.micro"
}
variable "instance_keypair" {
  default = "tunacademy"
}
locals {
  common = {
    "enviroment" = "terraform"
  }
}
