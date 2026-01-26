locals {
  jump_host_key = "jump_host"
}


#  create  security group

resource "aws_security_group" "jump_host_sg" {
  name        = "${local.jump_host_key}_sg"
  description = "Allow ssh (22) from any where"
  vpc_id      = aws_vpc.kts_vpc.id

  tags = {
    project_name = local.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_jump_host" {
  security_group_id = aws_security_group.jump_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_jump_host" {
  security_group_id = aws_security_group.jump_host_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# create ec2 instance
resource "aws_instance" "jump_host" {
  ami           = local.ubuntu_ami_id
  instance_type = var.ec2_config[local.jump_host_key]["instance_type"]
  key_name      = aws_key_pair.keys[local.jump_host_key].key_name
  subnet_id     = aws_subnet.public[local.jump_host_key].id


  vpc_security_group_ids = [
    aws_security_group.jump_host_sg.id
  ]

  tags = {
    Name         = "${local.jump_host_key}-server"
    project_name = local.project_name
  }

}

resource "aws_eip" "jump_host_eip" {
  domain = "vpc"
  tags = {
    Name         = "${local.jump_host_key}-eip"
    project_name = local.project_name
  }
}
resource "aws_eip_association" "jump_host_eip_association" {
  instance_id   = aws_instance.jump_host.id
  allocation_id = aws_eip.jump_host_eip.id
}

