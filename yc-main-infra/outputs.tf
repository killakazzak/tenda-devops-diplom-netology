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
