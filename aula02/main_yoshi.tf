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

resource "aws_instance" "ec2-iac-aula2" {
    ami = "ami-0e86e20dae9224db8"
    instance_type = "t2.micro"

    tags = {
        Name = "ec2-iac-aula2"
    }  

    ebs_block_device { // Bloco de armazenamento (disco)
        device_name = "/dev/sda1"
        volume_size = 30
        volume_type = "gp3"
    }

    // aqui associamos a ec2 a um security group criado em arquivos .tf
    // criamos o "sg_aula_iac" aqui mesmo nesse arquivo
    security_groups = [aws_security_group.sg_aula_iac.name, "default"]

    // nome da chave pem criada no console da AWS
    key_name = "aula_iac"

    // assim é caso queira indicar uma subnet da AWS
    // subnet_id = "subnet-0de234ff41781b5cc" // Subnet padrão da região us-east-1
    
    // assim é caso queira indicar uma subnet criada em arquivos .tf
    // criamos a "minha_subrede" aqui mesmo nesse arquivo
    subnet_id = aws_subnet.minha_subrede.id
}

// exemplos de variáveis no Terraform
variable "porta_http" {
    description = "porta http"
    default = 80
    type = number
}

variable "porta_https" {
    description = "porta https"
    default = 443
    type = number
}

// aqui criamos o security group "sg_aula_iac"
resource "aws_security_group" "sg_aula_iac" {
  name = "sg_aula_iac"

  # entrada SSH do IP da região
  # consutando os IPs das regiões: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-tutorial.html
  # e https://ip-ranges.amazonaws.com/ip-ranges.json (é um JSON bem grande)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.206.107.24/29", "0.0.0.0/0"]
  }

  ingress {
    from_port   = var.porta_http // usamos a variável porta_http
    to_port     = var.porta_http // usamos a variável porta_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.porta_http // usamos a variável porta_http
    to_port     = var.porta_http // usamos a variável porta_http
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = var.porta_https // usamos a variável porta_https
    to_port     = var.porta_https // usamos a variável porta_https
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.porta_https // usamos a variável porta_https
    to_port     = var.porta_https // usamos a variável porta_https
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// aqui criamos a subnet "minha_subrede"
resource "aws_subnet" "minha_subrede" {
    vpc_id = "vpc-0b5d3463975f7229a"
    cidr_block = "172.31.0.0/16" // bloco de IP da subnet
}











