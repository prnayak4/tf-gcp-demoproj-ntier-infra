resource "google_compute_network" "custom" {
  project                 = var.ProjectID
  name                    = "custom"
  auto_create_subnetworks = "false" 
  routing_mode            = "GLOBAL"
  mtu                     = 1460
}

resource "google_compute_subnetwork" "web" {
project                 = var.ProjectID
  name          = "web"
  ip_cidr_range = "10.10.10.0/24"
  network       = google_compute_network.custom.id
  region        = "europe-west1"

  secondary_ip_range  = [
    {
        range_name    = "services"
        ip_cidr_range = "10.10.11.0/24"
    },
    {
        range_name    = "pods"
        ip_cidr_range = "10.1.0.0/20"
    }
  ]

  private_ip_google_access = true
}

resource "google_compute_subnetwork" "data" {
 project                 = var.ProjectID
  name          = "data"
  ip_cidr_range = "10.20.10.0/24"
  network       = google_compute_network.custom.id
  region        = "europe-west1"

  private_ip_google_access = true
}


 resource "google_compute_global_address" "private-ip-peering" {
 project                 = var.ProjectID
  name          = "google-managed-services-custom1"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.custom.id
}
 


resource "google_service_networking_connection" "private-vpc-connection" {
  network = google_compute_network.custom.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private-ip-peering.name
  ]
}
