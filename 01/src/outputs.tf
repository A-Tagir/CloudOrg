output "vm_public_external_ip_address" {
  value = [
            yandex_compute_instance.public.name,
            yandex_compute_instance.public.network_interface[0].nat_ip_address,
            yandex_compute_instance.public.fqdn
          ]
 description = "vm public external ip"
}
#
#output "vm_db_external_ip_address" {
#  value = [
#            yandex_compute_instance.platform1.name,
#            yandex_compute_instance.platform1.network_interface.0.nat_ip_address,
#            yandex_compute_instance.platform1.fqdn
#          ]
# description = "vm db external ip"
#}
