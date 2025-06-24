resource "yandex_storage_bucket" "netology-bucket" {
  bucket    = "tagir-neto-bucket"
  acl       = "public-read"
  folder_id = var.folder_id
}

resource "yandex_storage_object" "image" {
  key    = "netology.jpg"
  bucket = yandex_storage_bucket.netology-bucket.bucket
  source = "./file/c27e121e-00ae-4163-86fb-3a66a299b1d3.jpg"
}
