provider "google" {
  credentials = file("account.json")
  project = var.project
  region  = "us-east1"
  zone    = "us-east1-c"
}
