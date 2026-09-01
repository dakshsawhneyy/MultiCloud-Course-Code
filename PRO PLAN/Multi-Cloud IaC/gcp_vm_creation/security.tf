resource "google_compute_firewall" "allow_ssh" {
  name    = "terraform-allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["terraform-vm"]
}
