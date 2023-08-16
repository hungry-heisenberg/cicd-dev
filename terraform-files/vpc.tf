# Network setup
resource "aws_vpc" "lnp_aws_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "lnp_aws_vpc"
  }
}
#

resource "aws_subnet" "lnp_aws_subnet" {
  vpc_id                                      = aws_vpc.lnp_aws_vpc.id
  cidr_block                                  = "10.0.1.0/24"
  availability_zone                           = var.az
  map_public_ip_on_launch                     = true
  assign_ipv6_address_on_creation             = false
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "lnp_aws_subnet"
  }
}
#

resource "aws_subnet" "lnp_aws_subnet2" {
  vpc_id                                      = aws_vpc.lnp_aws_vpc.id
  cidr_block                                  = "10.0.2.0/24"
  availability_zone                           = var.az2
  map_public_ip_on_launch                     = true
  assign_ipv6_address_on_creation             = false
  enable_resource_name_dns_a_record_on_launch = true

  tags = {
    Name = "lnp_aws_subnet2"
  }
}
#
resource "aws_internet_gateway" "lnp_aws_internet_gateway" {
  vpc_id = aws_vpc.lnp_aws_vpc.id

  tags = {
    Name = "lnp_aws_internet_gateway"
  }
}
#

resource "aws_route_table" "lnp_aws_route_table" {
  vpc_id = aws_vpc.lnp_aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lnp_aws_internet_gateway.id
  }

  tags = {
    Name = "lnp_aws_route_table"
  }
}
#

resource "aws_route_table_association" "lnp_aws_route_table_association" {
  subnet_id      = aws_subnet.lnp_aws_subnet.id
  route_table_id = aws_route_table.lnp_aws_route_table.id
}

resource "aws_route_table_association" "lnp_aws_route_table_association2" {
  subnet_id      = aws_subnet.lnp_aws_subnet2.id
  route_table_id = aws_route_table.lnp_aws_route_table.id
}



