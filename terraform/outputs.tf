output "app_server_ip" {
  value       = aws_instance.app_server.public_ip
  description = "Public IP of the app server — paste this into ansible/inventory.ini"
}
