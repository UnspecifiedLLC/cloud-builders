variable "project-name" {
  default = "cloud-builders-un-life"
}

variable "backend-bucket" {
  default = "terraform-builder-example-tfstate.unspecified.life"
}

variable "backend-bucket-prefix"
  default = "tf/terraform.tfstate"
}

variable "subnetwork_region" {
  default = "us-west1"
}

variable "region" {
  default = "us-west1-a" # Oregon
}