resource "yandex_iam_service_account" "sa-tenda-admin" {
  name        = "sa-tenda"
  description = "admin account"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-tenda-admin" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-admin.id}"
}

resource "yandex_iam_service_account_key" "sa-tenda-key" {
  service_account_id = yandex_iam_service_account.sa-tenda-admin.id
}

resource "local_file" "sa-tenda-key-file" {
  content  = yandex_iam_service_account_key.sa-tenda-key.private_key
  filename = "/home/tenda/tenda-devops-diplom-netology/key.json"

  depends_on = [yandex_iam_service_account_key.sa-tenda-key]
}

