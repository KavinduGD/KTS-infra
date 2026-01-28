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


resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.kts_vpc.id
  cidr_block        = each.value
  availability_zone = var.az

  tags = {
    Name         = "public_${each.key}"
    project_name = local.project_name
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.kts_vpc.id
  cidr_block        = each.value
  availability_zone = var.az

  tags = {
    Name         = "private_${each.key}"
    project_name = local.project_name
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

resource "aws_route_table_association" "public_assoc" {
  for_each = var.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.kts_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name         = "private-route-table"
    project_name = local.project_name
  }
}

resource "aws_route_table_association" "private_assoc" {
  for_each = var.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_rt.id
}




resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name         = "nat-eip"
    project_name = local.project_name
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public["nat"].id
}
