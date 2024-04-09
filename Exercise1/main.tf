# ---------creating virtual manchines------
# ====Create an instance called webserver1=====
resource "google_compute_instance" "webserver1" {
  name         = var.instance_name1
  machine_type = "e2-micro"
  zone         = "europe-west2-b"
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "philipnet"
    access_config {}
  }
}

# =====Create an instance called webserver2=====
resource "google_compute_instance" "webserver2" {
  name         = var.instance_name2
  machine_type = "e2-micro"
  zone         = "europe-west2-b"
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "philipnet"
    access_config {}
  }
}

# ====Create an instance called webserver3=====
resource "google_compute_instance" "webserver3" {
  name         = var.instance_name3
  machine_type = "e2-micro"
  zone         = "europe-west2-b"
  tags         = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "philipnet"
    access_config {}
  }
}

# ------------create an instance group----------------
resource "google_compute_instance_group" "webservers" {
  name        = "webservers"
  description = "My instance group description"
  zone        = "europe-west2-b"

  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 443
  }

  instances = [
    google_compute_instance.webserver1.self_link,
    google_compute_instance.webserver2.self_link,
    google_compute_instance.webserver3.self_link,
  ]
}

# --------------creating load balancer----------------
resource "google_compute_backend_service" "ilb-http-backend-service" {
  name        = "ilb-http-backend-service"
  protocol    = "HTTP"
  timeout_sec = 30
  enable_cdn  = false

  backend {
    group = google_compute_instance_group.webservers.self_link
  }

  health_checks = [google_compute_http_health_check.ilb-health-check.id]
}

resource "google_compute_http_health_check" "ilb-health-check" {
  name               = "ilb-health-check"
  request_path       = "/"
  check_interval_sec = 10
  timeout_sec        = 10
}

resource "google_compute_global_forwarding_rule" "ilb_frontend_rule" {
  name       = "ilb-frontend-rule"
  target     = google_compute_target_http_proxy.ilb_http_proxy.self_link
  port_range = "80"
  ip_address = google_compute_global_address.ilb_frontend_ip.address
}

resource "google_compute_target_http_proxy" "ilb_http_proxy" {
  name    = "ilb-http-proxy"
  url_map = google_compute_url_map.ilb_url_map.self_link
}

resource "google_compute_url_map" "ilb_url_map" {
  name            = "ilb-url-map"
  default_service = google_compute_backend_service.ilb-http-backend-service.self_link
}

resource "google_compute_global_address" "ilb_frontend_ip" {
  name = "ilb-frontend-ip-address"
}

resource "google_compute_firewall" "allow-access-lb-health-checks" {
  name    = "allow-http-lb-health-checks"
  network = "philipnet"

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  # Load balancer health checks use the IP range 130.211.0.0/22 and 35.191.0.0/16
  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["http-server", "https-server"]
}

# -------------create local file called vmip--------------
resource "local_file" "vmip" {
  depends_on = [google_compute_instance.webserver1, google_compute_instance.webserver2, google_compute_instance.webserver3]
  filename   = "/vagrant/ansible/vmip.ini"
  content    = join("\n", [google_compute_instance.webserver1.network_interface[0].access_config[0].nat_ip, google_compute_instance.webserver2.network_interface[0].access_config[0].nat_ip, google_compute_instance.webserver3.network_interface[0].access_config[0].nat_ip])
}