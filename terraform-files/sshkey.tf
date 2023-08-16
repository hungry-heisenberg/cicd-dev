resource "tls_private_key" "lnp_sshkeypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

/* output "lnp_sshkeypair_private" {
  value     = tls_private_key.lnp_sshkeypair.private_key_pem
  sensitive = true
} */

resource "local_file" "private_key" {
  content         = tls_private_key.lnp_sshkeypair.private_key_pem
  filename        = "LNPsshkey"
  file_permission = "0600"
}

resource "aws_key_pair" "lnp_sshkeypair_public" {
  key_name   = "LNPsshkey-pub"
  public_key = tls_private_key.lnp_sshkeypair.public_key_openssh
}