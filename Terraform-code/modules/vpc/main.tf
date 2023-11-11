####################################################################################
# VPC
####################################################################################

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"

    tags = {
    "Name" = "new-vpc"
  }
}

####################################################################################
# 2xSUBNET
####################################################################################

resource "aws_subnet" "subnets" {
count = length(var.subnet_cidr)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet_names[count.index]
  }
}

####################################################################################
# Inernet Gateway
####################################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

    tags = {
    "Name" = "new-igw"
  }
}

####################################################################################
# Route Table
####################################################################################

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0" #making it public
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "new-route-table"
  }
}

####################################################################################
# Route Table Association
####################################################################################

resource "aws_route_table_association" "route_table_association" {
  count = length(var.subnet_cidr)
  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.route_table.id
}

####################################################################################