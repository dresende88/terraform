// Launch Template lab

resource "aws_launch_template" "template" {
  name_prefix            = "lab-lt-"
  image_id               = local.ami_id
  vpc_security_group_ids = [aws_security_group.sg_web_server.id]
  key_name               = local.ec2_key
  //  iam_instance_profile   = aws_iam_instance_profile.lab_profile.name
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.environment}-${local.app}-AS"
      Environment = var.environment
      Costcenter  = var.costcenter_id
      Country     = var.country
      City        = var.city
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = "${var.environment}-${local.app}-AS"
      Environment = var.environment
      Costcenter  = var.costcenter_id
      Country     = var.country
      City        = var.city
    }
  }
}