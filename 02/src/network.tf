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

resource "yandex_vpc_subnet" "private" {
  name           = var.private_net_name
  zone           = var.cloud_zone
  network_id     = yandex_vpc_network.cloud-netology.id
  v4_cidr_blocks = var.private_cidr
#  route_table_id = yandex_vpc_route_table.rt-nat.id
}

