output "all_vm" {
  value = flatten([
    [for i in yandex_compute_instance.control-plane : {
      name        = i.name
      ip_external = i.network_interface[0].nat_ip_address
      ip_internal = i.network_interface[0].ip_address
    }],
    [for i in yandex_compute_instance.data-plane : {
      name        = i.name
      ip_external = i.network_interface[0].nat_ip_address
      ip_internal = i.network_interface[0].ip_address
    }]
  ])
}

output "api_endpoint" {
  value = yandex_compute_instance.control-plane[0].network_interface[0].nat_ip_address
}

output "worker_ip" {
  value = [
    yandex_compute_instance.data-plane[0].network_interface[0].ip_address,
    yandex_compute_instance.data-plane[1].network_interface[0].ip_address
  ]
}

output "Grafana_Network_Load_Balancer_Address" {
  value       = yandex_lb_network_load_balancer.lb-grafana.listener.*.external_address_spec[0].*.address
  description = "Адрес сетевого балансировщика для Grafana"
}

output "Web_App_Network_Load_Balancer_Address" {
  value       = yandex_lb_network_load_balancer.lb-web-app.listener.*.external_address_spec[0].*.address
  description = "Адрес сетевого балансировщика Web App"
}
