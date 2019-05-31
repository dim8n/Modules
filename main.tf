provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

data "aws_vpc" "selected" {
}
data "aws_subnet_ids" "example" {
  vpc_id = "${data.aws_vpc.selected.id}"
}
data "aws_subnet" "example" {
  count = "${length(data.aws_subnet_ids.example.ids)}"
  id    = "${tolist(data.aws_subnet_ids.example.ids)[count.index]}"
}

# security groups
resource "aws_security_group" "TF_HTTP_INTERNAL_ONLY" {
  name        = "TF_HTTP_INTERNAL"
  description = "HTTP_ONLY_INTERNAL"
  tags = {
      Name = "TF_HTTP_ONLY_INTERNAL"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks     = "${data.aws_subnet.example.*.cidr_block}"
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

# launch configuration
resource "aws_launch_configuration" "as_conf" {
  name          = "TF_launch_conf"
  #image_id      = "ami-0ebb3a801d5fb8b9b"
  image_id      = "ami-0c6b1d09930fac512"
  instance_type = "t2.micro"
  user_data = "${file("start_script.sh")}"
  security_groups  = ["${aws_security_group.TF_HTTP_INTERNAL_ONLY.id}"]
  associate_public_ip_address = "false"
  enable_monitoring = "false"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }
}

# target group fot load balancer
resource "aws_lb_target_group" "TF_target_group" {
  name     = "TF-target-group"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = "${data.aws_vpc.selected.id}"
}

# load balancer
resource "aws_lb" "TF_ALB" {
  name               = "TF-app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.TF_HTTP_ONLY.id}"]
  subnets             = "${data.aws_subnet.example.*.id}"
}

#listener for load balancer
resource "aws_lb_listener" "TF_ALB" {  
  load_balancer_arn = "${aws_lb.TF_ALB.arn}"  
  port              = 80  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.TF_target_group.arn}"
    type             = "forward"  
  }
}

# auto scaling group
resource "aws_autoscaling_group" "TF_auto_scaling_group" {
  name                      = "TF_auto_scaling_group"
  max_size                  = 7
  min_size                  = 0
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 7
  force_delete              = true
  target_group_arns         = ["${aws_lb_target_group.TF_target_group.arn}"]
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
  vpc_zone_identifier       = "${data.aws_subnet.example.*.id}"
  tags = [
      {
        key                 = "Name"
        value               = "TF_web_server"
        propagate_at_launch = true
      }
    ]
  }