output "dns_name" {
  description = "DNS Name of the master load balancer"
  value       = "${aws_lb.TF_ALB.dns_name}"
}