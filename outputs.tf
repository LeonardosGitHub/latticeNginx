output "A-aws-Region" {
  value = var.aws_region
}

output "appZone-vpc-id" {
  value = aws_vpc.terraform-vpc-appZone.id
}

output "secZone-vpc-id" {
  value = aws_vpc.terraform-vpc-securityZone.id
}

output "lattice_server_dns" {
    value = aws_vpclattice_service.latticePOC_service_appVpc.dns_entry[0].domain_name
}

# output "AWS_Nginx_secZone_Public_IP" {
#   value = aws_instance.secZone_nginx_instance.public_ip
# }

output "AWS_Nginx_plus_secZone_Public_IP" {
  value = aws_instance.secZone-nginx-plus_instance.public_ip
}

output "AWS_Nginx_appZone_Public_IP" {
  value = aws_instance.appZone_nginx_instance.public_ip
}

output "secZone_nginx-lb_DNS_Name" {
  value = aws_lb.secZone-nginx-lb.dns_name
}

# output "LatticePrefix-list" {
#   value = data.aws_ec2_managed_prefix_list.regionlatticeprefixlist
# }

# output "vpc-public-a" {
#   value = aws_subnet.public-a.cidr_block
# }

# output "vpc-public-a-id" {
#   value = aws_subnet.public-a.id
# }

# output "vpc-private-a" {
#   value = aws_subnet.private-a.cidr_block
# }

# output "vpc-private-a-id" {
#   value = aws_subnet.private-a.id
# }

# output "vpc-public-b" {
#   value = aws_subnet.public-b.cidr_block
# }

# output "vpc-public-b-id" {
#   value = aws_subnet.public-b.id
# }

# output "vpc-private-b" {
#   value = aws_subnet.private-b.cidr_block
# }

# output "vpc-private-b-id" {
#   value = aws_subnet.private-b.id
# }

# output "sshKey" {
#   value = var.ssh_key
#   sensitive = true
# }

# output "managementSubnetAz2" {
#   value = aws_subnet.f5-management-b.id
# }

# output "restrictedSrcAddress" {
#   value = var.restrictedSrcAddress
# }

# output "Locust_Master_Server_Public_IP" {
#   #value = aws_instance.app1_instance.public_ip
#   value = format("%s%s","ssh -i .ssh/gitlabPrivate.key -o 'StrictHostKeyChecking no' ubuntu@",aws_instance.app1_instance.public_ip)
# }

# output "Locust_worker0_Server_Public_IP" {
#   value = format("%s%s%s","ssh -i .ssh/gitlabPrivate.key -o 'StrictHostKeyChecking no' ubuntu@",aws_instance.app_worker_instances[0].public_ip," nohup locust --config worker.conf &")
# }
# output "Locust_worker1_Server_Public_IP" {
#   value = format("%s%s%s","ssh -i .ssh/gitlabPrivate.key -o 'StrictHostKeyChecking no' ubuntu@",aws_instance.app_worker_instances[1].public_ip," nohup locust --config worker.conf &")
# }
# output "Locust_worker2_Server_Public_IP" {
#   value = format("%s%s%s","ssh -i .ssh/gitlabPrivate.key -o 'StrictHostKeyChecking no' ubuntu@",aws_instance.app_worker_instances[2].public_ip," nohup locust --config worker.conf &")
# }
# output "Locust_worker3_Server_Public_IP" {
#   value = format("%s%s%s","ssh -i .ssh/gitlabPrivate.key -o 'StrictHostKeyChecking no' ubuntu@",aws_instance.app_worker_instances[3].public_ip," nohup locust --config worker.conf &")
# }