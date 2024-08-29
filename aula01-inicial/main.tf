
# Configuração Inicial
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

# Criando chave pem
variable "key_pair_name" {
  type = string
  default = "id_rsa"
}

resource "aws_key_pair" "generated_key" {
  key_name = var.key_pair_name
  public_key = file("id_rsa.pem.pub")
}

# Criando grupo de segurança
resource "aws_security_group" "basic_security" {
  name        = "basic_security"
  description = "Allow SSH access"
  vpc_id      = "vpc-06d53b263d38b0727"

  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Criando instancia EC2
resource "aws_instance" "ec2-terraform" {
    ami                    = "ami-0e86e20dae9224db8"               # SO
    availability_zone      = "us-east-1a"
    instance_type          = "t2.small"                            # Tipo
    ebs_block_device {
      device_name          = "/dev/sda1"
      volume_size          = 40
      volume_type          = "gp3"
    }
    key_name               = aws_key_pair.generated_key.key_name   # Nome da chave pem
    vpc_security_group_ids = [aws_security_group.basic_security]

    tags = {
        Name = "ec2-terraform"
    }
}
