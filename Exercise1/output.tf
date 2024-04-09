output "instance_ip1" {
  value = google_compute_instance.webserver1.network_interface[0].access_config[0].nat_ip
}

output "instance_ip2" {
  value = google_compute_instance.webserver2.network_interface[0].access_config[0].nat_ip
}

output "instance_ip3" {
  value = google_compute_instance.webserver3.network_interface[0].access_config[0].nat_ip
}

output "ilb-ip" {
  value       = google_compute_global_forwarding_rule.ilb_frontend_rule.ip_address
  description = "The IP of the load balancer frontend service"
}