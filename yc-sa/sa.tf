#Создание cервисного аккаунта
resource "yandex_iam_service_account" "sa-tenda-admin" {
  name        = "sa-tenda"
  description = "admin account"
}

#Назначение роли
resource "yandex_resourcemanager_folder_iam_member" "sa-tenda-admin" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-admin.id}"
}


#Создание авторизованного ключа для сервисных аккаунтов и его запись в файл key.json
resource "yandex_iam_service_account_key" "sa-tenda-key" {
  service_account_id = yandex_iam_service_account.sa-tenda-admin.id
  key_algorithm      = "RSA_2048"
}

resource "local_file" "sa-key-file" {
  filename = var.key_file_path
  content = jsonencode({
    "id"                 = yandex_iam_service_account_key.sa-tenda-key.id
    "service_account_id" = yandex_iam_service_account.sa-tenda-admin.id
    "private_key"        = yandex_iam_service_account_key.sa-tenda-key.private_key
    "public_key"         = yandex_iam_service_account_key.sa-tenda-key.public_key
  })
  depends_on = [
    yandex_iam_service_account_key.sa-tenda-key
  ]
}
