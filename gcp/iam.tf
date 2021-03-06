# Role binding to service account
resource "google_project_iam_binding" "container_admin" {
  role = "roles/container.admin"

  members = [
    "${formatlist("user:%s",var.bastion_admin_emails)}",
  ]
}

resource "google_project_iam_binding" "container_viewer" {
  role = "roles/container.viewer"

  members = [
    "${formatlist("user:%s",var.bastion_user_emails)}",
    "serviceAccount:${google_service_account.bastion.email}",
  ]
}

resource "google_project_iam_binding" "compute_os_login_users" {
  role = "roles/compute.osLogin"

  members = [
    "${formatlist("user:%s",var.bastion_user_emails)}",
  ]
}

resource "google_project_iam_binding" "compute_os_login_admins" {
  role = "roles/compute.osAdminLogin"

  members = [
    "${formatlist("user:%s",var.bastion_admin_emails)}",
  ]
}

resource "google_service_account_iam_binding" "bastion_svc_acc_users" {
  service_account_id = "${google_service_account.bastion.name}"
  role               = "roles/iam.serviceAccountUser"

  members = [
    "${formatlist("user:%s",var.bastion_user_emails)}",
    "${formatlist("user:%s",var.bastion_admin_emails)}",
  ]
}

// Enables Audit Logs of Users SSH session into Bastion via IAP in StackDriver
resource "google_project_iam_audit_config" "iap" {
  "audit_log_config" {
    log_type = "DATA_READ"
  }

  "audit_log_config" {
    log_type = "DATA_WRITE"
  }

  "audit_log_config" {
    log_type = "ADMIN_READ"
  }

  service = "iap.googleapis.com"
}
