output "region" {
  description = "Display region"
  value       = "${var.region}"
}

output "dns_name" {
  description = "DNS Name of the master load balancer"
  value       = "${aws_lb.TF_ALB.dns_name}"
}

output "subnets" {
  value = "${data.aws_subnet.example.*.id}"
}

output "subnet_cidr_blocks" {
  value = ["${data.aws_subnet.example.*.cidr_block}"]
}

data "aws_ami" "linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amazon-eks-node-*"]  
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["602401143452"] # Amazon
}

output "image_id" {
  value = ["${data.aws_ami.linux.*.id}"]
}
