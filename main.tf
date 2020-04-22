terraform {
  backend "s3" {
    bucket = "hslogscloudtrail"
    key    = "sample/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

locals {
  name        = "test-server"
  keyname     = "test"
  size        = "t2.small"
  vol_type_so = "gp2"
  vol_size_so = "10"
  ami_id      = "ami-0fc61db8544a617ed"
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["test"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["test"]
  }
}

data "aws_subnet" "test" {
  count = "${length(data.aws_subnet_ids.private.ids)}"
  id    = "${tolist(data.aws_subnet_ids.private.ids)[count.index]}"
}