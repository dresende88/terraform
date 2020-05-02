terraform {
  backend "s3" {
    bucket = "hslogscloudtrail"
    key    = "environment/lab/terraform.tfstate"
    region = "us-east-1"
  }
}