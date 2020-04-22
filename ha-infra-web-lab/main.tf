
terraform {
  backend "s3" {
    bucket = "hslogscloudtrail"
    key    = "environment/lab/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.aws_region
}

locals {
  environment              = "LAB"
  ami_id                   = "ami-0323c3dd2da7fb37d"
  ec2_key                  = "key"
  memcached_engine_version = "1.5.16"
  redis_engine_version     = "5.0.6"
  memcached_engine         = "memcached"
  redis_engine             = "redis"
  node                     = "cache.t3.micro"
  num_nodes                = "1"
  memcached_port           = "11211"
  redis_port               = "6379"
  family                   = "empty"
  app                      = var.name
}

data "aws_availability_zones" "available" {
  state = "available"
}


