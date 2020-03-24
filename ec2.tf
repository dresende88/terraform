resource "aws_instance" "test" {
  ami           = local.ami_id
  key_name      = local.keyname
  instance_type = local.size
  security_groups             = [aws_security_group.test-sg.id]
  subnet_id                   = data.aws_subnet.test.0.id
  associate_public_ip_address = false

  root_block_device {
    volume_type           = local.vol_type_so
    volume_size           = local.vol_size_so
    delete_on_termination = true
  }

  tags = {
    Name    = local.name
    company = local.company
    env     = local.env
    group   = local.group
    role    = local.role
    system  = local.system
    type    = local.type
  }
}

resource "aws_security_group" "test-sg" {
  name        = "test-security-group"
  description = "Security Group for bastion server DB"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "officeBF"
    cidr_blocks = ["10.30.0.0/16", "10.80.0.0/16"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    description = "Allow MySQL port"
    cidr_blocks = ["10.130.0.0/16", "10.110.0.0/16", "10.100.0.0/16"]
  }
  }

