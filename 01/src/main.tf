resource "yandex_vpc_network" "cloud-netology" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.public_net_name
  zone           = var.cloud_zone
  network_id     = yandex_vpc_network.cloud-netology.id
  v4_cidr_blocks = var.public_cidr
#  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_compute_instance" "nat" {
name         = var.nat_vm_name
platform_id  = var.vm_nat_platform_id
  resources {
    cores = var.vms_resources.nat.cores
    memory = var.vms_resources.nat.memory
    core_fraction = var.vms_resources.nat.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = "fd8baf5utqs2h3f5sod1"
    }
  }
  scheduling_policy {
    preemptible = var.vm_nat_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat = var.vm_nat_nat
  }

  metadata = {
    serial-port-enable = var.metadata_resources.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_resources.ssh-keys}"
  }

}


resource "yandex_vpc_subnet" "private" {
  name           = var.private_net_name
  zone           = var.cloud_zone
  network_id     = yandex_vpc_network.cloud-netology.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.rt-nat.id
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

resource "yandex_compute_instance" "public" {
  name         = var.vm_public_name
  platform_id  = var.vm_public_platform_id

  resources {

    cores = var.vms_resources.public.cores
    memory = var.vms_resources.public.memory
    core_fraction = var.vms_resources.public.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_public_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat = var.vm_public_nat

  }

  metadata = {
    serial-port-enable = var.metadata_resources.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_resources.ssh-keys}"
  }

}

resource "yandex_vpc_route_table" "rt-nat" {
  network_id = yandex_vpc_network.cloud-netology.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

resource "yandex_compute_instance" "private" {
  name         = var.vm_private_name
  platform_id  = var.vm_private_platform_id

  resources {

    cores = var.vms_resources.private.cores
    memory = var.vms_resources.private.memory
    core_fraction = var.vms_resources.private.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_private_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat = var.vm_private_nat

  }

  metadata = {
    serial-port-enable = var.metadata_resources.serial-port-enable
    ssh-keys           = "ubuntu:${var.metadata_resources.ssh-keys}"
  }

} 

