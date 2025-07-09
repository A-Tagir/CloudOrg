//
// Create a new Managed Kubernetes zonal Cluster.
//
resource "yandex_kubernetes_cluster" "netology-cluster" {
  name        = "netology-cluster"
  description = "3 zone Kubernetes cluster"

  network_id = yandex_vpc_network.cloud-netology.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = var.public1_zone
        subnet_id = yandex_vpc_subnet.public1.id
      }

      location {
        zone      = var.public2_zone
        subnet_id = yandex_vpc_subnet.public2.id
      }

      location {
        zone      = var.public3_zone
        subnet_id = yandex_vpc_subnet.public3.id
      }
    }

    public_ip = true

    security_group_ids = [yandex_vpc_security_group.kube_sg.id]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }

  }

  service_account_id      =  yandex_iam_service_account.k8s_sa.id
  node_service_account_id =  yandex_iam_service_account.k8s_sa.id

  labels = {
    my_key       = "my_key"
    my_other_key = "my_other_key"
  }

  release_channel         = "RAPID"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-bucket.id
  }

 depends_on = [
    yandex_resourcemanager_folder_iam_binding.editor,
    yandex_resourcemanager_folder_iam_binding.k8s_agent,
    yandex_resourcemanager_folder_iam_binding.vpc_admin,
    yandex_resourcemanager_folder_iam_binding.kms_access
  ]

}

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  cluster_id  = yandex_kubernetes_cluster.netology-cluster.id
  name        = "test-group"
  description = "description"

  labels = {
    "group_name" = "test-group"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public1.id]
      nat = true
    }

    resources {
      core_fraction = 20
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    auto_scale {
      min = "3"
      max = "6"
      initial = "3"
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
   depends_on = [yandex_kubernetes_cluster.netology-cluster, yandex_vpc_security_group.kube_sg]
}
resource "yandex_vpc_security_group" "kube_sg" {
  name        = "k8s-security-group"
  network_id  = yandex_vpc_network.cloud-netology.id
  
  #ingress {
  #protocol       = "TCP"
  #port           = 6443  # Kubernetes API
  #v4_cidr_blocks = ["0.0.0.0/0"]  # Или ограничьте до своих IP
  #}

  ingress {
    description    = "Cluster"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_iam_service_account" "k8s_sa" {
  name        = "k8s-service-account"
  description = "Service account for Kubernetes cluster"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.folder_id
  role      = "editor"
  members   = ["serviceAccount:${yandex_iam_service_account.k8s_sa.id}"]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  members   = ["serviceAccount:${yandex_iam_service_account.k8s_sa.id}"]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc_admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  members   = ["serviceAccount:${yandex_iam_service_account.k8s_sa.id}"]
}

resource "yandex_resourcemanager_folder_iam_binding" "kms_access" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  members   = ["serviceAccount:${yandex_iam_service_account.k8s_sa.id}"]
}
