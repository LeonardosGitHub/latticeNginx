resource "aws_key_pair" "app-keypair" {
  key_name   = format("%s-key-%s", var.projectPrefix, random_id.buildSuffix.hex)
  public_key = var.ssh_key
  tags = {
    Owner = "leonardo.simon@f5.com"
  }
}

# Create Target Group
resource "aws_lb_target_group" "secZone-nginx-tg" {
  name                = format("%s-tg-%s-1", var.projectPrefix, random_id.buildSuffix.hex)
  port                = 80
  target_type         = "instance"
  protocol            = "TCP"
  proxy_protocol_v2   = false
  preserve_client_ip  = false
  vpc_id            = aws_vpc.terraform-vpc-securityZone.id
  tags = {
    Owner = var.resourceOwner
  }
}

resource "aws_lb_target_group_attachment" "secZone-tg-attach" {
  target_group_arn = aws_lb_target_group.secZone-nginx-tg.arn
  target_id        = aws_instance.secZone-nginx-plus_instance.id
  port             = 80
}

# AWS Listener for Network Load Balancer
resource "aws_lb_listener" "nginx-nlb-Listener" {
  load_balancer_arn = aws_lb.secZone-nginx-lb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.secZone-nginx-tg.arn
    type             = "forward"
  }
  tags = {
    Owner = var.resourceOwner
  }
}

# AWS Network Load Balancer
resource "aws_lb" "secZone-nginx-lb" {
  name               = format("%s-nlb-%s", var.projectPrefix, random_id.buildSuffix.hex)
  internal           = false
  load_balancer_type = "network"
  enable_cross_zone_load_balancing = true
  subnets            = [aws_subnet.public-a.id,aws_subnet.public-b.id]

  tags = {
    Name  = "${var.projectPrefix}-nlb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}

data "aws_ec2_managed_prefix_list" "regionlatticeprefixlist" {
  name = "com.amazonaws.${var.aws_region}.vpc-lattice"
}
