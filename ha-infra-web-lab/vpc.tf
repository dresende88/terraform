// VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

// Subnets

resource "aws_subnet" "private" {
  count             = 6
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index)
  vpc_id            = aws_vpc.vpc.id
  tags = {
    "Name" = "Private-subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_subnet" "public" {
  count             = 6
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(var.vpc_cidr1, 3, count.index)
  vpc_id            = aws_vpc.vpc.id
  tags = {
    "Name" = "Public-subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

// Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet Gateway lab public subnet"
  }
}

// NAT Gateway

resource "aws_nat_gateway" "nat" {
  count         = length(data.aws_availability_zones.available.names)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.private.*.id, count.index)

  tags = {
    Name = "NAT Gateway LAB ${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

// Nat Gateway Elastic IP

resource "aws_eip" "nat" {
  count = length(data.aws_availability_zones.available.names)
  vpc   = true
}

// Public Route table

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route"
  }
}

//Public Route table association 

resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public_route.id
}

//Private Route table

resource "aws_route_table" "private_route" {
  count  = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-route"
  }
}

resource "aws_route" "private_route" {
  count                  = length(data.aws_availability_zones.available.names)
  route_table_id         = element(aws_route_table.private_route.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
}

//Private Route table association 

resource "aws_route_table_association" "private" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private_route.*.id, count.index)
}
