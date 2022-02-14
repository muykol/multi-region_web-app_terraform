# -----modules/compute/main.tf

data "aws_ami" "linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_launch_template" "web_server" {
  name_prefix            = "muyo-webserver"
  image_id               = data.aws_ami.linux.id
  instance_type          = var.web_server_instance_type
  vpc_security_group_ids = [var.web_sg]
  key_name               = var.key_name
  user_data              = filebase64("install_php_server.sh")
  
  iam_instance_profile {
      name = "web_instance_profile"
  }

  tags = {
    Name = "muyo-webserver"
  }
}

resource "aws_autoscaling_group" "web_server" {
  name                = "webserver_asg"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 1

  launch_template {
    id      = aws_launch_template.web_server.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web_server.id
  alb_target_group_arn = var.alb_tg
}

# ....EC2 Instance Role..... #

resource "aws_iam_role" "ssm_role" {
  name             = "ssm_role"
  path             = "/"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "web_instance_profile" {
  name = "server-role"
  role = aws_iam_role.ssm_role.name
}