resource "aws_security_group" "appZone-nginx-sg" {
  name        = format("%s-appZone-nginx-sg-%s", var.projectPrefix, random_id.buildSuffix.hex)
  description = "Allow inbound traffic to nginx"
  vpc_id      = aws_vpc.terraform-vpc-appZone.id

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.terraform-vpc-appZone.cidr_block]
  }

  ingress {
    description      = "Allow Lattice to HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    prefix_list_ids  = [data.aws_ec2_managed_prefix_list.regionlatticeprefixlist.id]
  }

  ingress {
    description      = "Allow HTTP Connect"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.terraform-vpc-appZone.cidr_block]
  }

  ingress {
    description      = "Allow GUI management"
    from_port        = 8443
    to_port          = 8443
    protocol         = "tcp"
    cidr_blocks      = var.restrictedSrcAddress
  }

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.restrictedSrcAddress
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "${var.projectPrefix}-appZone-nginx-sg-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

locals {
  appZone_nginx_onboard = templatefile("${path.module}/files/nginx_init_server.tmpl", {
    aws_region        = var.aws_region
  }
  )
}

resource "aws_instance" "appZone_nginx_instance" {
  ami           = var.web_server_ami[var.aws_region]
  instance_type = "m5.24xlarge"
  subnet_id                   = aws_subnet.public-a_appZone.id
  vpc_security_group_ids      = [aws_security_group.appZone-nginx-sg.id]
  key_name                    = aws_key_pair.app-keypair.key_name
  associate_public_ip_address = true
  #private_ip             = aws_subnet.private_subnets_vpc1[0].id
  tags = {
      Name  = "${var.projectPrefix}-appZone-nginx-${random_id.buildSuffix.hex}"
      Owner: var.resourceOwner
  }
  user_data                   = base64encode(local.appZone_nginx_onboard)

}
