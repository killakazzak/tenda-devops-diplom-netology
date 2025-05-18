resource "yandex_vpc_network" "tenda-net" {
  name      = var.vpc_name
  folder_id = var.folder_id
}


resource "yandex_vpc_subnet" "central1-a" {
  name           = "central1-a"
  zone           = var.zone_a
  network_id     = yandex_vpc_network.tenda-net.id
  v4_cidr_blocks = ["10.0.10.0/24"]
}

resource "yandex_vpc_subnet" "central1-b" {
  name           = "central1-b"
  zone           = var.zone_b
  network_id     = yandex_vpc_network.tenda-net.id
  v4_cidr_blocks = ["10.0.20.0/24"]
}

resource "yandex_vpc_subnet" "central1-d" {
  name           = "central1-d"
  zone           = var.zone_d
  network_id     = yandex_vpc_network.tenda-net.id
  v4_cidr_blocks = ["10.0.30.0/24"]
}
