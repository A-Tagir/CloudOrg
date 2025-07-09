
output "cluster_id" {
  description = "ID of a new Kubernetes cluster."

  value = yandex_kubernetes_cluster.netology-cluster.id
}

output "external_v4_endpoint" {
  description = "An IPv4 external network address that is assigned to the master."
  value = yandex_kubernetes_cluster.netology-cluster.master[0].external_v4_endpoint
}

output "cluster_hosts_fqdns" {
  value = ["${yandex_mdb_mysql_cluster.netology-cluster.host.*.fqdn}"]
}