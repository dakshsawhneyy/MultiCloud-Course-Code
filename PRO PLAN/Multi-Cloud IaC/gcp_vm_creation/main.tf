resource "google_compute_instance" "vm" {
  name         = "terraform-demo-vm"
  machine_type = "e2-micro"
  zone         = "asia-south1-a"

  tags = ["terraform-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
}
