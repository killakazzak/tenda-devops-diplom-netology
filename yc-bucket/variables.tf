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
