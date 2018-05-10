//See Terraform docs re: configuring back ends: https://www.terraform.io/docs/backends/types/gcs.html
terraform {
  backend "gcs" {
    bucket  = "builder-example-terraform-state.unspecified.life"
    prefix  = "tf/terraform.tfstate"
    project = "cloud-builders-un-life"
  }
}