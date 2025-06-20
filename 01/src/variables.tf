###cloud vars

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "cloud_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "public_cidr" {
  type        = list(string)
  default     = ["192.168.10.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "private_cidr" {
  type        = list(string)
  default     = ["192.168.20.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "cloud-netology"
  description = "VPC network & subnet name"
}

variable "public_net_name" {
  type        = string
  default     = "cloud-net-public"
  description = "VPC network & subnet name"
}

variable "private_net_name" {
  type        = string
  default     = "cloud-net-private"
  description = "VPC network & subnet name"
}

variable "nat_vm_name" {
  type        = string
  default     = "cloud-nat-instance"
  description = "nat instance name"
}

variable "token" {
  type        = string
  default     = ""
  sensitive   = true
  description = "IAM token"
}

variable "vm_family" {
  type        = string
  default     = "ubuntu-2204-lts"
  description  = "VM os family"
}

variable "vm_public_name" {
  type        = string
  default     = "cloud-public"
  description  = "compute instance name"
}

variable "vm_public_platform_id" {
  type        = string
  default     = "standard-v1"
  description  = "yandex platform type"
}

variable "vm_nat_platform_id" {
  type        = string
  default     = "standard-v1"
  description  = "yandex platform type"
}

#variable "vm_web_serial-port-enable" {
#  type        = number
#  default     = 1
#  description  = "VM serial port"
#}

variable "vm_public_preemptible" {
  type        = bool
  default     = true
  description  = "VM preemtible or not"
}

variable "vm_nat_preemptible" {
  type        = bool
  default     = true
  description  = "VM preemtible or not"
}

variable "vm_public_nat" {
  type        = bool
  default     = false
  description  = "VM nat"
}

variable "vms_resources" {
   type = map(map(number))
   description = "VM resources map"
}

variable "metadata_resources" {
   type = map(any)
   description = "VM metadata map"
}

###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "<your_ssh_ed25519_key>"
#  description = "ssh-keygen -t ed25519"
#}
