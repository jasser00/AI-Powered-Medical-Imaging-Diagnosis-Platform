module "bation_ec2_instance" {
  depends_on = [module.bation_sg]
  source     = "terraform-aws-modules/ec2-instance/aws"
  name       = "bation_instance-1"

  instance_type          = var.instance_type
  ami                    = data.aws_ami.ubuntu_ami.id
  key_name               = var.instance_keypair
  vpc_security_group_ids = [module.bation_sg.security_group_id]
  subnet_id              = module.test_vpc.public_subnets["0"]

  tags = local.common
}
output "ec2_bation_public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.bation_ec2_instance.public_ip
}
output "ec2_bation_id" {
  description = "The ID of the instance"
  value       = module.bation_ec2_instance.id
}
module "bation_sg" {
  source = "terraform-aws-modules/security-group/aws"

  description = "public ssh to acces bastion from outside vpc"
  name        = "bation-SG"
  vpc_id      = module.test_vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
  tags = {
    Name = "Bation_host_SG"
  }
}
output "bation_security_group_id" {
  description = "The ID of the security group"
  value       = module.bation_sg.security_group_id
}

output "bation_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.bation_sg.security_group_vpc_id
}

output "bation_security_group_name" {
  description = "The name of the security group"
  value       = module.bation_sg.security_group_name
}
resource "aws_eip" "EIP_bation" {
  depends_on = [module.bation_ec2_instance, module.test_vpc]
  instance   = module.bation_ec2_instance.id
  domain     = "vpc"
  tags       = local.common
}
resource "null_resource" "cluster" {
  depends_on = [module.bation_ec2_instance, module.test_vpc]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    password    = ""
    host        = aws_eip.EIP_bation.public_ip
    private_key = file("./tunacademy.pem")
  }
  provisioner "file" {
    source      = "./tunacademy.pem"
    destination = "/tmp/tunacadem.pem"
  }

  provisioner "remote-exec" {
    inline = ["sudo chmod 400 /tmp/tunacadem.pem"]
  }
  provisioner "local-exec" {
    command    = "echo bation connected to private instance"
    on_failure = continue
  }
}

