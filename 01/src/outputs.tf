output "vm_public_external_ip_address" {
  value = [
            yandex_compute_instance.public.name,
            yandex_compute_instance.public.network_interface[0].nat_ip_address,
            yandex_compute_instance.public.fqdn
          ]
 description = "vm public external ip"
}

output "vm_private_internal_ip_address" {
  value = [
            yandex_compute_instance.private.name,
            yandex_compute_instance.private.network_interface[0].ip_address,
            yandex_compute_instance.private.fqdn
          ]
 description = "vm private internal ip"
}