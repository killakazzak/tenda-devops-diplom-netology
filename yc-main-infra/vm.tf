resource "yandex_compute_instance" "control-plane" {
  count = 1
  name  = "master-${count.index}"
  zone  = var.subnet-zones[count.index]



  resources {
    cores  = 2
    memory = 4
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-zones[count.index].id
    nat       = true
  }
  boot_disk {
    initialize_params {
      image_id = "fd8huqdhr65m771g1bka"
      type     = "network-hdd"
      size     = "50"
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "data-plane" {
  count = 2
  name  = "worker-${count.index}"
  zone  = var.subnet-zones[count.index]
  scheduling_policy {
    preemptible = true
  }
  labels = {
    index = count.index
  }
  resources {
    cores  = 2
    memory = 4
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-zones[count.index].id
    nat       = true
  }


  boot_disk {
    initialize_params {
      image_id = "fd8huqdhr65m771g1bka"
      type     = "network-hdd"
      size     = "50"
    }
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
