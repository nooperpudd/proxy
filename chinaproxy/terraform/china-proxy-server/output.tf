output "instance_ip_addr" {
  value = aws_instance.proxy_server.public_ip
}