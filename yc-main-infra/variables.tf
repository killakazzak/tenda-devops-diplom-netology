variable "token" {
  type        = string
  description = "Yandex Cloud AuthToken"
  sensitive   = true
}

variable "cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "Yandex Cloud Folder ID"
  sensitive   = true
}

variable "zone_a" {
  type        = string
  description = "Yandex Cloud default zone"
  default     = "ru-central1-a"
}

variable "zone_b" {
  type        = string
  description = "Yandex Cloud default zone"
  default     = "ru-central1-b"
}

variable "zone_d" {
  type        = string
  description = "Yandex Cloud default zone"
  default     = "ru-central1-d"
}

variable "subnet-zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-c"]
}

variable "cidr" {
  type = map(list(string))
  default = {
    stage = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }
}

variable "key_file_path" {
  type        = string
  description = "Yandex Cloud default zone"
  default     = "/home/tenda/tenda-devops-diplom-netology/key.json"
}
