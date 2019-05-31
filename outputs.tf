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
