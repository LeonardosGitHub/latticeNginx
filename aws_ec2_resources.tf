resource "aws_key_pair" "app-keypair" {
  key_name   = format("%s-key-%s", var.projectPrefix, random_id.buildSuffix.hex)
  public_key = var.ssh_key
  tags = {
    Owner = "leonardo.simon@f5.com"
  }
}