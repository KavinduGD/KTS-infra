locals {
  sonaq_key = "sonaq"
}


#  create  security group

resource "aws_security_group" "sonaq_sg" {
  name        = "${local.sonaq_key}_sg"
  description = "Allow 9000 from jenkins"
  vpc_id      = aws_vpc.kts_vpc.id

  tags = {
    project_name = local.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_9000_ipv4_sonaq" {
  security_group_id = aws_security_group.sonaq_sg.id
  # cidr_ipv4         = "0.0.0.0/0"
  referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port                    = 9000
  to_port                      = 9000
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_9000_ipv4_jump_host" {
  security_group_id = aws_security_group.sonaq_sg.id
  # cidr_ipv4         = "0.0.0.0/0"
  referenced_security_group_id = aws_security_group.jump_host_sg.id
  from_port                    = 9000
  to_port                      = 9000
  ip_protocol                  = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_sonaq" {
  security_group_id            = aws_security_group.sonaq_sg.id
  referenced_security_group_id = aws_security_group.jump_host_sg.id
  # cidr_ipv4 = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_sonaq" {
  security_group_id = aws_security_group.sonaq_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# create ec2 instance
resource "aws_instance" "sonaq" {
  ami           = local.ubuntu_ami_id
  instance_type = var.ec2_config[local.sonaq_key]["instance_type"]
  key_name      = aws_key_pair.keys[local.sonaq_key].key_name
  subnet_id     = aws_subnet.private[local.sonaq_key].id



  vpc_security_group_ids = [
    aws_security_group.sonaq_sg.id
  ]

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name         = "${local.sonaq_key}-server"
    project_name = local.project_name
  }

}


