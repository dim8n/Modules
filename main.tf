provider "aws" {
    access_key = "AKIAJECVMYQBGQWDS6YQ"
    secret_key = "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"
    region = "eu-west-3"
}

data "aws_vpc" "selected" {
}

resource "aws_security_group" "TF_HTTP_INTERNAL_ONLY" {
  name        = "TF_HTTP_INTERNAL"
  description = "HTTP_ONLY_INTERNAL"
  tags = {
      Name = "TF_HTTP_ONLY_INTERNAL"
  }
  #vpc_id   = "${aws_vpc.main.id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks     = ["172.31.0.0/16"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "TF_HTTP_ONLY" {
  name        = "TF_HTTP"
  description = "HTTP_ONLY"
  tags = {
      Name = "TF_HTTP_ONLY"
  }
  #vpc_id   = "${aws_vpc.main.id}"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "as_conf" {
  name          = "TF_l_conf"
  image_id      = "ami-0ebb3a801d5fb8b9b"
  instance_type = "t2.micro"
  user_data = "${file("start_script.sh")}"
  security_groups  = ["${aws_security_group.TF_HTTP_ONLY.id}"]
  enable_monitoring = "false"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
}

resource "aws_lb_target_group" "TF_target_group" {
  name     = "TF-target-group"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = "${data.aws_vpc.selected.id}"
}

# load balancer
# auto scaling group