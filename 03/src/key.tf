resource "yandex_kms_symmetric_key" "key-bucket" {
  name                = "netology-bucket"
  description         = "key_for_encrypt_bucket"
  default_algorithm   = "AES_128"
  #rotation_period     = "8760h"
  #deletion_protection = true
  #lifecycle {
  #  prevent_destroy = true
  #}
}

resource "yandex_iam_service_account" "bucketsa" {
  name = "bucket-encrypt-account"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "bucket-admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.bucketsa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "kms-encrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.bucketsa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.bucketsa.id
  description        = "static access key for object storage"
}
