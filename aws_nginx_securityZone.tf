locals {
  secZone_nginx_onboard = templatefile("${path.module}/files/secZone_nginx_onboard.tmpl", {
    lattice_service_dns = aws_vpclattice_service.latticePOC_service_appVpc.dns_entry[0].domain_name
  }
  )
}

resource "aws_security_group" "secZone-nginx-sg" {
  name        = format("%s-secZone-nginx-sg-%s", var.projectPrefix, random_id.buildSuffix.hex)
  description = "Allow inbound traffic to nginx"
  vpc_id      = aws_vpc.terraform-vpc-securityZone.id

  ingress {
    description      = "Allow HTTP Connect"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.terraform-vpc-securityZone.cidr_block]
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

  ingress {
    description      = "Allow HTTP from F5 VPN"
    from_port        = 80
    to_port          = 80
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
    Name  = "${var.projectPrefix}-secZone-nginx-sg-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

resource "aws_instance" "secZone_nginx_instance" {
  ami           = var.web_server_ami[var.aws_region]
  instance_type = "m5.24xlarge"
  subnet_id                   = aws_subnet.public-a.id
  vpc_security_group_ids      = [aws_security_group.secZone-nginx-sg.id]
  key_name                    = aws_key_pair.app-keypair.key_name
  associate_public_ip_address = true
  tags = {
      Name  = "${var.projectPrefix}-secZone-nginx-${random_id.buildSuffix.hex}"
      Owner: var.resourceOwner
  }
  #user_data                  = "${file("files/nginx_init_server.sh")}"
  user_data                   = base64encode(local.secZone_nginx_onboard)

}
