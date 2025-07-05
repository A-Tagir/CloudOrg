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

resource "yandex_vpc_subnet" "private1" {
  name           = "cloud-net-private-zone-a"
  zone           = var.private1_zone
  network_id     = yandex_vpc_network.cloud-netology.id
  v4_cidr_blocks = var.private1_cidr
#  route_table_id = yandex_vpc_route_table.rt-nat.id
}

resource "yandex_vpc_subnet" "private2" {
  name           = "cloud-net-private-zone-b"
  zone           = var.private2_zone
  network_id     = yandex_vpc_network.cloud-netology.id
  v4_cidr_blocks = var.private2_cidr
#  route_table_id = yandex_vpc_route_table.rt-nat.id
}

resource "yandex_vpc_subnet" "private3" {
  name           = "cloud-net-private-zone-b1"
  zone           = var.private3_zone
  network_id     = yandex_vpc_network.cloud-netology.id
  v4_cidr_blocks = var.private3_cidr
#  route_table_id = yandex_vpc_route_table.rt-nat.id
}

