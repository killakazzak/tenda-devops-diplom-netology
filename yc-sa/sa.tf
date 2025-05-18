resource "yandex_iam_service_account" "sa-tenda-admin" {
  name        = "sa-tenda"
  description = "admin account"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-tenda-admin" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-admin.id}"
}
