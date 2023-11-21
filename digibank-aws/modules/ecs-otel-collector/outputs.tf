output "load_balancer_ip" {
  value = aws_lb.albcollector.dns_name
}