locals {
  depl_key = "depl"
}


#  create  security group

resource "aws_security_group" "depl_sg" {
  name        = "${local.depl_key}_sg"
  description = "Allow 3000, 5173, 5174 from load balancer, ssh from jump host"
  vpc_id      = aws_vpc.kts_vpc.id

  tags = {
    project_name = local.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_3000_ipv4_depl" {
  security_group_id = aws_security_group.depl_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  #   referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_5173_ipv4_depl" {
  security_group_id = aws_security_group.depl_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  #   referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port   = 5173
  to_port     = 5173
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_5174_ipv4_depl" {
  security_group_id = aws_security_group.depl_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  #   referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port   = 5174
  to_port     = 5174
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_depl" {
  security_group_id            = aws_security_group.depl_sg.id
  referenced_security_group_id = aws_security_group.jump_host_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_jump_host_jenkins_sg_depl" {
  security_group_id            = aws_security_group.depl_sg.id
  referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_depl" {
  security_group_id = aws_security_group.depl_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# create ec2 instance
resource "aws_instance" "depl" {
  ami           = local.ubuntu_ami_id
  instance_type = var.ec2_config[local.depl_key]["instance_type"]
  key_name      = aws_key_pair.keys[local.depl_key].key_name
  subnet_id     = aws_subnet.private[local.depl_key].id



  vpc_security_group_ids = [
    aws_security_group.depl_sg.id
  ]

  root_block_device {
    volume_size           = 20    
    volume_type           = "gp3" 
    delete_on_termination = true
  }

  tags = {
    Name         = "${local.depl_key}-server"
    project_name = local.project_name
  }

}


