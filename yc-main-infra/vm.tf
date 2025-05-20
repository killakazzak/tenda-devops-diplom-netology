locals {
  ssh-keys         = fileexists("~/.ssh/id_rsa.pub") ? file("~/.ssh/id_rsa.pub") : var.ssh_public_key
  ssh-private-keys = fileexists("~/.ssh/id_rsa") ? file("~/.ssh/id_rsa") : var.ssh_private_key
}

data "template_file" "cloudinit" {
  template = file("${path.module}/cloud-init.yaml")
  vars = {
    ssh_public_key  = local.ssh-keys
    ssh_private_key = local.ssh-private-keys
  }
}
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
    ssh-keys           = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = "1"
    user-data          = data.template_file.cloudinit.rendered
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
    ssh-keys           = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    serial-port-enable = "1"
    user-data          = data.template_file.cloudinit.rendered
  }
}
