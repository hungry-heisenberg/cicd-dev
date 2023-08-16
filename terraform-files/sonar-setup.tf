resource "aws_security_group" "lnp_sonar_sg" {
  name        = "lnp_sonar_sg"
  description = "Allow needed ports like ssh, http, https etc"
  vpc_id      = aws_vpc.lnp_aws_vpc.id

  ingress {
    description      = "Sonar Web Console"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Sonar SSH"
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

output "sonar-securityGroupId" {
  value = aws_security_group.lnp_sonar_sg.id
}


resource "aws_instance" "sonar-box" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  availability_zone      = var.az
  subnet_id              = aws_subnet.lnp_aws_subnet.id
  key_name               = aws_key_pair.lnp_sshkeypair_public.key_name
  vpc_security_group_ids = [aws_security_group.lnp_sonar_sg.id]



  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 20
  }
  user_data = file("./scripts/sonar-setup.sh")
  tags = {
    Name = "sonar-box"
  }

}

output "sonar_public_ip" {
  value = aws_instance.sonar-box.public_ip
}

output "sonar_instance_id" {
  value = aws_instance.sonar-box.id
}

output "sonar_public_dns" {
  value = aws_instance.sonar-box.public_dns
}
