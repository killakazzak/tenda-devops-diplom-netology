# Создаем DNS-зону
resource "yandex_dns_zone" "denisten_ru" {
  name        = "denisten-ru"
  description = "Main DNS zone"
  zone        = "denisten.ru."
  folder_id   = var.folder_id
  public      = true
}

# Получаем информацию о балансировщике по его имени
data "yandex_lb_network_load_balancer" "lb-ingress" {
  name = "lb-ingress" # Указываем имя балансировщика
}

resource "yandex_dns_recordset" "denisten_ru_a" {
  zone_id = yandex_dns_zone.denisten_ru.id
  name    = "denisten.ru."
  type    = "A"
  ttl     = 600
  data = flatten([
    for listener in data.yandex_lb_network_load_balancer.lb-ingress.listener :
    [for address in listener.external_address_spec : address.address]
  ])
}

output "lb_listener" {
  value = flatten([
    for listener in data.yandex_lb_network_load_balancer.lb-ingress.listener :
    [for address in listener.external_address_spec : address.address]
  ])
}
