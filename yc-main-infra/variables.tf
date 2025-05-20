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

variable "key_file_path" {
  type        = string
  description = "Yandex Cloud default zone"
  default     = "/home/tenda/tenda-devops-diplom-netology/key.json"
}

variable "subnet-zones" {
  type    = list(string)
  default = ["ru-central1-a", "ru-central1-b", "ru-central1-d"]
}

variable "cidr" {
  type = map(list(string))
  default = {
    stage = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  }
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  default     = ""
}

variable "ssh_private_key" {
  description = "SSH private key"
  type        = string
  default     = ""
}
