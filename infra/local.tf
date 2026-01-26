locals {
  project_name = "KTS"
}

# get the latest ubuntu  ami
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20251212"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}


locals {
  ubuntu_ami_id = data.aws_ami.ubuntu.id
}