# lattice Nginx +

The 4 sensitive variables will have to be pulled from secrets or defined locally.
- var.ssh_key - uploads public key to be used for the EC2 instances
- var.f5_password - this is not used in this repo, left over from re-used code
- var.nginxRepoCrt - this is provided by F5/Nginx when you subscribe to Nginx Plus
- var.nginxRepoKey - this is provided by F5/Nginx when you subscribe to Nginx Plus


Here's an example to apply via terraform using locally defined variables:
- terraform apply -var "ssh_key=$ssh_key" -var 'f5_password=$f5_password' -var "nginxRepoCrt=$nginxRepoCrt" -var "nginxRepoKey=$nginxRepoKey"