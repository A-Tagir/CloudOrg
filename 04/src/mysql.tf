resource "yandex_mdb_mysql_cluster" "netology-cluster" {
  name                = "netologydb"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.cloud-netology.id
  version             = "8.0"
  security_group_ids = [yandex_vpc_security_group.mysql_sg.id]
  deletion_protection = false

  maintenance_window {
    type = "ANYTIME"
  }
  
  backup_window_start {
    hours = "23"
    minutes = "59"
  }

  resources {
    resource_preset_id = "b2.medium"
    disk_type_id       = "network-ssd"
    disk_size          = "20"
  }

 

  host {
    zone             = var.private1_zone
    subnet_id        = yandex_vpc_subnet.private1.id
    #priority         = 100
    backup_priority  = 100
  }

  host {
    zone             = var.private2_zone
    subnet_id        = yandex_vpc_subnet.private2.id
    #priority         = 100
    backup_priority  = 50
  }

  host {
    zone             = var.private3_zone
    subnet_id        = yandex_vpc_subnet.private3.id
    priority         = 50
    backup_priority  = 50
  }

 depends_on = [
     yandex_vpc_network.cloud-netology,
     yandex_vpc_subnet.private1,
     yandex_vpc_subnet.private2,
     yandex_vpc_subnet.private3,
     yandex_vpc_security_group.mysql_sg
  ]

}

resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.netology-cluster.id
  name       = "netology_db"
  depends_on = [
     yandex_mdb_mysql_cluster.netology-cluster
  ]
}

resource "yandex_mdb_mysql_user" "tagir" {
  cluster_id = yandex_mdb_mysql_cluster.netology-cluster.id
  name       = "tagir"
  password   = var.db_password
  depends_on = [
     yandex_mdb_mysql_cluster.netology-cluster
  ]
  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}

resource "yandex_vpc_security_group" "mysql_sg" {
  name        = "mysql-security-group"
  network_id  = yandex_vpc_network.cloud-netology.id

  ingress {
    description    = "MySQL"
    #port           = 3306
    #protocol       = "TCP"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    #v4_cidr_blocks = ["192.168.0.0/16", "10.0.0.0/16"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}