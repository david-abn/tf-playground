locals {
  nat_count = var.single_nat_gateway ? 1 : 3
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}



resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.env}-public-rt"
  }
}


resource "aws_subnet" "public_subnets" {
  count = 3

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-subnet-${count.index}"
  }
}

resource "aws_route_table_association" "public_subnets_rt_association" {
  count          = 3
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnets" {
  count = 3

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.main_vpc.cidr_block, 8, count.index + 10) // Do not overlap with public subnets
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.env}-subnet-private-${count.index}"
  }
}

resource "aws_eip" "nat_eip" {
  count = local.nat_count

  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_nat_gateway" "main_natgw" {
  count = local.nat_count

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.env}-natgw-${count.index}"
  }
}

resource "aws_route_table" "private_rt" {
  count = 3

  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_natgw[var.single_nat_gateway ? 0 : count.index].id
  }

  tags = {
    Name = "${var.env}-private-rt-${count.index}"
  }
}

resource "aws_route_table_association" "private_subnets_rt_association" {
  count          = 3
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}
