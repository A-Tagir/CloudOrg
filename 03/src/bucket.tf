resource "yandex_storage_bucket" "netology-bucket" {
  bucket    = "tagir-neto-bucket"
  acl       = "private"
  folder_id = var.folder_id
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  force_destroy=true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-bucket.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
depends_on = [
    yandex_resourcemanager_folder_iam_member.bucket-admin,
    yandex_resourcemanager_folder_iam_member.kms-encrypter,
  ]
}

resource "yandex_storage_object" "image" {
  key    = "netology.jpg"
  acl    = "private"
  bucket = yandex_storage_bucket.netology-bucket.bucket
  source = "./file/c27e121e-00ae-4163-86fb-3a66a299b1d3.jpg"
}
