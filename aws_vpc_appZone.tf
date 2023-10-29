########################################
# BUILDING THE VPC FOR THE ENVIRONMENT #
########################################

resource "aws_vpc" "terraform-vpc-appZone" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  #enable_classiclink   = "false"

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_${var.projectPrefix}"
  }
}

resource "aws_default_security_group" "default_appZone" {
  vpc_id = aws_vpc.terraform-vpc-appZone.id
  tags = {
    Owner = var.resourceOwner
  }
}

#################################################
# BUILDING SUBNETS FOR VPC IN TWO DIFFERENT AZ'S#
#################################################

resource "aws_subnet" "f5-management-a_appZone" {
  vpc_id                  = aws_vpc.terraform-vpc-appZone.id
  cidr_block              = "10.0.101.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_management-a_${var.projectPrefix}"
  }
}

resource "aws_subnet" "f5-management-b_appZone" {
  vpc_id                  = aws_vpc.terraform-vpc-appZone.id
  cidr_block              = "10.0.102.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}b"

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_management-b_${var.projectPrefix}"
  }
}

resource "aws_subnet" "public-a_appZone" {
  vpc_id                  = aws_vpc.terraform-vpc-appZone.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_public-a_${var.projectPrefix}"
  }
}

resource "aws_subnet" "public-b_appZone" {
  vpc_id                  = aws_vpc.terraform-vpc-appZone.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}b"

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_public-b_${var.projectPrefix}"
  }
}

resource "aws_subnet" "private-a_appZone" {
  vpc_id                  = aws_vpc.terraform-vpc-appZone.id
  cidr_block              = "10.0.100.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}a"

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_private-a_${var.projectPrefix}"
  }
}

resource "aws_subnet" "private-b_appZone" {
  vpc_id                  = aws_vpc.terraform-vpc-appZone.id
  cidr_block              = "10.0.200.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.aws_region}b"

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_private-b_${var.projectPrefix}"
  }
}

######################################
# BUILDING INTERNET GATEWAY & ROUTING#
######################################

resource "aws_internet_gateway" "gw_appZone" {
  vpc_id = aws_vpc.terraform-vpc-appZone.id

  tags = {
    Owner = var.resourceOwner
    Name = "terraform_internet-gateway_${var.projectPrefix}"
  }
}

resource "aws_route_table" "rt1_appZone" {
  vpc_id = aws_vpc.terraform-vpc-appZone.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_appZone.id
  }

  tags = {
    Owner = "leonardo.simon@f5.com"
    Name = "terraform_default_route_${var.projectPrefix}"
  }
}

resource "aws_main_route_table_association" "association-subnet_appZone" {
  vpc_id         = aws_vpc.terraform-vpc-appZone.id
  route_table_id = aws_route_table.rt1_appZone.id
}
