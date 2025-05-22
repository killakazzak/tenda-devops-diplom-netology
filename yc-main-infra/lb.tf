resource "yandex_lb_target_group" "lb-group" {
  name      = "lb-group"
  region_id = "ru-central1"

  dynamic "target" {
    for_each = yandex_compute_instance.data-plane
    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}

resource "yandex_lb_network_load_balancer" "lb-grafana" {
  name = "lb-grafana"

  listener {
    name        = "listener-grafana"
    port        = 80
    target_port = 30050
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-group.id

    healthcheck {
      name = "http-healthcheck"
      tcp_options {
        port = 30050
      }
    }
  }
  depends_on = [yandex_lb_target_group.lb-group]
}

resource "yandex_lb_network_load_balancer" "lb-web-app" {
  name = "lb-web-app"

  listener {
    name        = "listener-web-app"
    port        = 80
    target_port = 30051
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.lb-group.id

    healthcheck {
      name = "http-healthcheck"
      tcp_options {
        port = 30051
      }
    }
  }
  depends_on = [yandex_lb_network_load_balancer.lb-grafana]
}
