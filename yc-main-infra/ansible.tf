data "template_file" "inventory" {
  template = file("${path.module}/templates/inventory.tpl")

  vars = {
    hosts_control = "${join("\n", formatlist("%s ansible_host=%s ansible_user=ubuntu", yandex_compute_instance.control.*.name, yandex_compute_instance.control.*.network_interface.0.nat_ip_address))}"
    hosts_worker  = "${join("\n", formatlist("%s ansible_host=%s ansible_user=ubuntu", yandex_compute_instance.worker.*.name, yandex_compute_instance.worker.*.network_interface.0.nat_ip_address))}"
    list_control  = "${join("\n", yandex_compute_instance.control.*.name)}"
    list_worker   = "${join("\n", yandex_compute_instance.worker.*.name)}"
  }
}

resource "null_resource" "inventory-render" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ./kubespray/inventory/mycluster/inventory-${terraform.workspace}.ini"
  }

  triggers = {
    template = data.template_file.inventory.rendered
  }
}


