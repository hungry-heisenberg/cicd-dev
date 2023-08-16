resource "aws_security_group" "lnp_nexus_sg" {
  name        = "lnp_nexus_sg"
  description = "Allow needed ports like ssh, http, https etc"
  vpc_id      = aws_vpc.lnp_aws_vpc.id

  ingress {
    description      = "Nexus Web Console"
    from_port        = 8081
    to_port          = 8081
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Nexus SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "nexus-securityGroupId" {
  value = aws_security_group.lnp_nexus_sg.id
}


resource "aws_instance" "nexus-box" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.az
  subnet_id              = aws_subnet.lnp_aws_subnet.id
  key_name               = aws_key_pair.lnp_sshkeypair_public.key_name
  vpc_security_group_ids = [aws_security_group.lnp_nexus_sg.id]



  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
  }
  user_data = file("./scripts/nexus-repo-setup.sh")
  tags = {
    Name = "nexus-box"
  }

}

output "nexus_public_ip" {
  value = aws_instance.nexus-box.public_ip
}

output "nexus_instance_id" {
  value = aws_instance.nexus-box.id
}

output "nexus_public_dns" {
  value = aws_instance.nexus-box.public_dns
}
