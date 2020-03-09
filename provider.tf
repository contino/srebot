provider "google" {
  credentials = file("account.json")
  project = var.project
  region  = va.location
  #zone    = "us-east1-c"
}
