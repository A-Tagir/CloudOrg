output "Network_Load_Balancer_Address" {
  value = yandex_lb_network_load_balancer.lb-1.listener.*.external_address_spec[0].*.address
  description = "Адрес сетевого балансировщика"
} 