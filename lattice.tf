#######################################
### CREATES LATTICE SERVICE NETWORK ###
#######################################

resource "aws_vpclattice_service_network" "latticePOC" {
  name      = "lsimonlatticepoc"
  auth_type = "NONE"
  tags = {
    Owner = var.resourceOwner
    Name = "terraform_${var.projectPrefix}"
  }
}

#########################################
### ASSOC. VPC'd WITH SERVICE NETWORK ###
#########################################

resource "aws_vpclattice_service_network_vpc_association" "latticePOC_appVpc" {
  vpc_identifier             = aws_vpc.terraform-vpc-appZone.id
  service_network_identifier = aws_vpclattice_service_network.latticePOC.id
  tags = {
    Owner = var.resourceOwner
    Name = "terraform_${var.projectPrefix}"
  }
}

resource "aws_vpclattice_service_network_vpc_association" "latticePOC_secVpc" {
  vpc_identifier             = aws_vpc.terraform-vpc-securityZone.id
  service_network_identifier = aws_vpclattice_service_network.latticePOC.id
  tags = {
    Owner = var.resourceOwner
    Name = "terraform_${var.projectPrefix}"
  }
}

#######################################
### CREATE SERVICE FOR LATTICE      ###
#######################################

resource "aws_vpclattice_service" "latticePOC_service_appVpc" {
  name = "latticepocappvpc"
  tags = {
    Owner = var.resourceOwner
    Name = "terraform_${var.projectPrefix}"
  }
}

resource "aws_vpclattice_target_group" "latticePOC_tg_appVpc" {
  name = "latticepoctargetgroupappvpc"
  type = "INSTANCE"

  config {
    port           = 80
    protocol       = "HTTP"
    vpc_identifier = aws_vpc.terraform-vpc-appZone.id
  }
  tags = {
    Owner = var.resourceOwner
    Name = "terraform_${var.projectPrefix}"
  }
}

resource "aws_vpclattice_listener" "latticePOC" {
  name               = "latticepoclistnerappvpc"
  protocol           = "HTTP"
  service_identifier = aws_vpclattice_service.latticePOC_service_appVpc.id
  default_action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.latticePOC_tg_appVpc.id
      }
    }
  }
  tags = {
    Owner = var.resourceOwner
    Name = "terraform_${var.projectPrefix}"
  }
}

resource "aws_vpclattice_target_group_attachment" "latticePOC" {
  target_group_identifier = aws_vpclattice_target_group.latticePOC_tg_appVpc.id

  target {
    id   = aws_instance.appZone_nginx_instance.id
  }
}

resource "aws_vpclattice_service_network_service_association" "latticePOC" {
  service_identifier         = aws_vpclattice_service.latticePOC_service_appVpc.id
  service_network_identifier = aws_vpclattice_service_network.latticePOC.id
}