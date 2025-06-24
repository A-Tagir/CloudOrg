resource "yandex_iam_service_account" "lamp-1-sa" {
  name        = "lamp-1-sa"
  description = "Service account for instance group"
}

resource "yandex_resourcemanager_folder_iam_binding" "network-user" {
  folder_id = var.folder_id
  role      = "admin"
  members   = ["serviceAccount:${yandex_iam_service_account.lamp-1-sa.id}"]
}

resource "yandex_compute_instance_group" "lamp-1" {
  name                = "ig-with-balancer-neto"
  folder_id           = var.folder_id
  service_account_id = yandex_iam_service_account.lamp-1-sa.id
  deletion_protection = false
  instance_template {
    platform_id = "standard-v1"
    resources {
      cores = var.vms_resources.lamp.cores
      memory = var.vms_resources.lamp.memory
      core_fraction = var.vms_resources.lamp.core_fraction
    }

    scheduling_policy {
      preemptible = var.vm_lamp_preemptible
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8tohhau5bm2emb9idl"
      }
    }

    network_interface {
      nat = var.vm_lamp_nat
      network_id         = yandex_vpc_network.cloud-netology.id
      subnet_ids         = [ yandex_vpc_subnet.public.id ]
      #  security_group_ids = ["<список_идентификаторов_групп_безопасности>"]
    }

    metadata = {
      serial-port-enable = var.metadata_resources.serial-port-enable
      ssh-keys           = "ubuntu:${var.metadata_resources.ssh-keys}"
      user-data = <<-EOT
        #!/bin/bash
        echo '<html><body><p>'$(hostname)'</p><img src="https://storage.yandexcloud.net/${yandex_storage_bucket.netology-bucket.bucket}/${yandex_storage_object.image.key}"></body></html>' > /var/www/html/index.html
        EOT
      }
    
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_binding.network-user, yandex_resourcemanager_folder_iam_binding.network-user,
  ]

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.cloud_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "ig-with-balancer-neto"
    target_group_description = "Целевая группа Network Load Balancer"
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp-1.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
depends_on = [
    yandex_resourcemanager_folder_iam_binding.network-user, yandex_resourcemanager_folder_iam_binding.network-user,
  ]

}