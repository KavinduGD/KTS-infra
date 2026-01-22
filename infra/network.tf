resource "aws_vpc" "kts_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name         = "kts_vpc"
    project_name = local.project_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.kts_vpc.id

  tags = {
    project_name = local.project_name
    Name         = "kts-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.kts_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name         = "public-route-table"
    project_name = local.project_name
  }
}


resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.kts_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name         = "public_1"
    project_name = local.project_name
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}


