# VPC


resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "eks-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

# Subnet

resource "aws_subnet" "subnet" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = "true"
  vpc_id            = aws_vpc.vpc.id

  tags = map(
    "Name", "eks-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

# Internet Gateway

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "eks-cluster"
  }
}


# Route table Public Subnet

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
}

# Route table Private Subnet

resource "aws_route_table_association" "rta" {
  count = 2

  subnet_id      = aws_subnet.subnet.*.id[count.index]
  route_table_id = aws_route_table.rt.id
}