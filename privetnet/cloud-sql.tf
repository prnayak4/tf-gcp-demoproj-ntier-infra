resource "random_string" "db_name_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_sql_database_instance" "mysql" {
 project                 = var.ProjectID
  # Instance info
  name             = "mysql-inst-${random_string.db_name_suffix.result}"
  region           = var.region
  database_version = var.mysql_database_version

  settings {

    # Region and zonal availability
    availability_type = var.mysql_availability_type
    location_preference {
      zone = var.mysql_location_preference
    }

    # Machine Type
    tier              = var.mysql_machine_type

    # Storage
    disk_size         = var.mysql_default_disk_size

    # Connections
    ip_configuration {
      ipv4_enabled        = false
      private_network     = google_compute_network.custom.id
    }

    # Backups
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "06:00"
    }
  }
  depends_on = [
    google_service_networking_connection.private-vpc-connection
  ]
}

data "google_secret_manager_secret_version" "wordpress-admin-user-password" {
 project                 = var.ProjectID
  secret = "wordpress-admin-user-password"
}

resource "google_sql_database" "wordpress" {
    project                 = var.ProjectID
  name     = "wordpress"
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "wordpress" {
    project                 = var.ProjectID
  name = var.SqluserName
  instance = google_sql_database_instance.mysql.name
  password = data.google_secret_manager_secret_version.wordpress-admin-user-password.secret_data
}
