# lattice Nginx +
This builds:
- 2 - VPC's and associated subnets, IG, etc
    - Security Zone VPC
    - Application Zone VPC
- Lattice
    - Lattice Service Network
    - Lattice Service
    - Target group
        - Targetting Application Zone Ubuntu/Nginx instance
- 2 - Ubuntu instances
    - 1 - is Security Zone VPC
        - Nginx Plus installed
        - Port 80 exposed with lattice service as proxy pass
    - 1 - in Application Zone VPC
        - Nginx OSS installed
        - used as web server
- NLB instance
    - targetting Security Zone Ubuntu/Nginx instance


The 4 sensitive variables will have to be pulled from secrets or defined locally.
- var.ssh_key - uploads public key to be used for the EC2 instances
- var.f5_password - this is not used in this repo, left over from re-used code
- var.nginxRepoCrt - this is provided by F5/Nginx when you subscribe to Nginx Plus
- var.nginxRepoKey - this is provided by F5/Nginx when you subscribe to Nginx Plus


Here's an example to apply via terraform using locally defined variables:
- terraform apply -var "ssh_key=$ssh_key" -var 'f5_password=$f5_password' -var "nginxRepoCrt=$nginxRepoCrt" -var "nginxRepoKey=$nginxRepoKey"