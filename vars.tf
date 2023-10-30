
variable "web_server_ami" {
  type = map(string)

  default = {
    #"us-east-1"      = "ami-a4c7edb2"
    #"ap-southeast-1" = "ami-77af2014"
    #"us-east-2"      = "ami-0ccabb5f82d4c9af5"  #Amazon Linux 2023 AMI
    "us-east-2"      = "ami-024e6efaf93d85776"
    #"us-west-2"      = "ami-6df1e514"
  }
}

variable "aws_region" {
  description = "aws region (default is us-east-2)"
  default     = "us-east-2"
}

variable "restrictedSrcAddress" {
  type        = list(string)
  description = "Lock down management access by source IP address or network"
  default     = ["104.219.105.84/32","162.220.44.18/32","50.236.107.2/32"]
}

variable "projectPrefix" {
  type        = string
  default     = "lsimon-LatticePOC"
  description = "This value is inserted at the beginning of each AWS object (alpha-numeric, no special character)"
}

variable "asg_min_size" {
  type        = number
  description = "AWS autoscailng minimum size"
  default     = 1
}
variable "asg_max_size" {
  type        = number
  description = "AWS autoscailng minimum size"
  default     = 5
}
variable "asg_desired_capacity" {
  type        = number
  description = "AWS autoscailng desired capacity"
  default     = 1
}
variable "f5_ami_search_name" {
  type        = string
  description = "AWS AMI search filter to find correct BIG-IP VE for region"
  # aws ec2 describe-images --filters "Name=name,Values=F5 BIGIP-15.1.5*Best Plus 1Gbps*" --query 'Images[*].[ImageId,Name]'
  #default     = "F5 BIGIP-15.1.5*Best Plus 5Gbps*"
  default     = "F5 BIGIP-16.1.3*Best Plus 5Gbps*"
}
variable "bigip_ec2_instance_type" {
  type        = string
  description = "AWS instance type for the BIG-IP"
  default     = "m5n.2xlarge"
}
variable "f5_username" {
  type        = string
  description = "User name for the BIG-IP (Note: currenlty not used. Defaults to 'admin' based on AMI"
  default     = "admin"
}
variable "f5_password" {
  type        = string
  sensitive   = true
  description = "BIG-IP Password"
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
  sensitive   = true
}
variable "dns_server" {
  type        = string
  default     = "8.8.8.8"
  description = "Leave the default DNS server the BIG-IP uses, or replace the default DNS server with the one you want to use"
}
variable "ntp_server" {
  type        = string
  default     = "0.us.pool.ntp.org"
  description = "Leave the default NTP server the BIG-IP uses, or replace the default NTP server with the one you want to use"
}
variable "timezone" {
  type        = string
  default     = "UTC"
  description = "If you would like to change the time zone the BIG-IP uses, enter the time zone you want to use. This is based on the tz database found in /usr/share/zoneinfo (see the full list [here](https://github.com/F5Networks/f5-azure-arm-templates/blob/master/azure-timezone-list.md)). Example values: UTC, US/Pacific, US/Eastern, Europe/London or Asia/Singapore."
}
variable "DO_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.30.0/f5-declarative-onboarding-1.30.0-3.noarch.rpm"
  description = "URL to download the BIG-IP Declarative Onboarding module"
}
variable "AS3_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.31.0/f5-appsvcs-3.31.0-6.noarch.rpm"
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
}
variable "TS_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.33.0/f5-telemetry-1.33.0-1.noarch.rpm"
  description = "URL to download the BIG-IP Telemetry Streaming module"
}
variable "FAST_URL" {
  description = "URL to download the BIG-IP FAST module"
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.19.0/f5-appsvcs-templates-1.19.0-1.noarch.rpm"
}
variable "INIT_URL" {
  description = "URL to download the BIG-IP runtime init"
  type        = string
  default     = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.5.0/dist/f5-bigip-runtime-init-1.5.0-1.gz.run"
}
variable "libs_dir" {
  description = "Directory on the BIG-IP to download the A&O Toolchain into"
  default     = "/config/cloud/aws/node_modules"
  type        = string
}
variable "onboard_log" {
  description = "Directory on the BIG-IP to store the cloud-init logs"
  default     = "/var/log/cloud/startup-script.log"
  type        = string
}

variable "resourceOwner" {
  type        = string
  default     = "leonardo.simon@f5.com"
  description = "This is a tag used for object creation. Example is last name."
}

variable "nginxRepoCrt" {
  type        = string
  description = "Provide as variable when applying terraform"
  sensitive   = true
}
variable "nginxRepoKey" {
  type        = string
  description = "Provide as variable when applying terraform"
  sensitive   = true
}