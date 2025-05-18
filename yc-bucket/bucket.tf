# Создание Service Account для Object Storage
resource "yandex_iam_service_account" "sa-tenda-storage" {
  name = "sa-tenda-storage"
}

# Назначение роли storage.editor
resource "yandex_resourcemanager_folder_iam_member" "storage-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-tenda-storage.id}"
}

# Создание статических ключей доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-tenda-storage.id
}

# Создание бакета
resource "yandex_storage_bucket" "tenda-s3-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "tenda-bucket"
  anonymous_access_flags {
    read = false
    list = false
  }
  acl           = "private"
  force_destroy = true
}
