resource "google_compute_instance" "vm" {
  name         = "terraform-demo-vm"
  machine_type = "e2-micro"
  zone         = "asia-south1-a"

  tags = ["terraform-vm"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
}
