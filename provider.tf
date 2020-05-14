provider "google" {
  #credentials = file("account.json")
  project = var.project
  region  = var.location
  #zone    = "us-east1-c"
}
