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

resource "aws_vpc" "vpc_teste" {
  cidr_block = "10.0.0.0/23"

  tags = {
    Name = "vpc_teste"
  }
}

resource "aws_subnet" "sub_pub" {
  vpc_id = aws_vpc.vpc_teste.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "sub_pub"
  }
}

resource "aws_subnet" "sub_pri" {
  vpc_id = aws_vpc.vpc_teste.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sub_pri"
  }
}

resource "aws_instance" "ec2_pub" {
   ami = "ami-0e86e20dae9224db8"
    instance_type = "t2.micro"

    tags = {
        Name = "ec2_pub"
    }  

    ebs_block_device { 
        device_name = "/dev/sda1"
        volume_size = 30
        volume_type = "gp3"
    }

    subnet_id = aws_subnet.sub_pub.id
}

resource "aws_instance" "ec2_pri" {
   ami = "ami-0e86e20dae9224db8"
    instance_type = "t2.micro"

    tags = {
        Name = "ec2_pub"
    }  

    ebs_block_device { 
        device_name = "/dev/sda1"
        volume_size = 30
        volume_type = "gp3"
    }

    subnet_id = aws_subnet.sub_pri.id
}