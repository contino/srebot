# enable the following: firebase, dialogflow, cloud functions
data "google_project" "agent_project" {
}

locals {
  zip_filename = "${var.bot_name}.zip"
}

resource "google_storage_bucket" "cf_bucket" {
  name = "${var.bot_name}_bu"
  project = data.google_project.agent_project.project_id
  bucket_policy_only = "true"
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir = "../${path.module}/${var.source_dir}/"
  output_path = "${path.module}/files/index.zip"
}

resource "google_storage_bucket_object" "cf_archive" {
  name   = "${var.bot_name}/index.zip"
  bucket = google_storage_bucket.cf_bucket.name
  source = data.archive_file.zip.output_path
}

resource "google_cloudfunctions_function" "cloud_function" {
  name                  = var.bot_name
  description           = var.description
  runtime               = var.runtime
  project               = data.google_project.agent_project.project_id
  available_memory_mb   = var.memory_size_mb
  source_archive_bucket = google_storage_bucket.cf_bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  timeout               = var.timeout
  entry_point           = var.entry_point
  region                = var.location
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.project
  cloud_function = google_cloudfunctions_function.cloud_function.name
  region         = google_cloudfunctions_function.cloud_function.region
  role   = "roles/cloudfunctions.invoker"
  member = google_project_iam_member.agent_create.member
  depends_on = [google_project_iam_member.agent_create]
}

resource template_dir "bot_dir" {
  source_dir  = "${path.module}/${var.bot_name}_template"
  destination_dir = "${path.module}/${var.bot_name}"
  vars = {
    webhook_url = "https://us-central1-bhood-214523.cloudfunctions.net/dialogflowFirebaseFulfillment"
  }
}

resource "google_project_service" "agent_project" {
  project = data.google_project.agent_project.project_id
  service = "dialogflow.googleapis.com"
}
	  
resource "google_project_iam_member" "agent_create" {
  project = data.google_project.agent_project.project_id
  role    = "roles/dialogflow.admin"
  member  = "serviceAccount:service-${data.google_project.agent_project.number}@gcp-sa-dialogflow.iam.gserviceaccount.com"
  depends_on = [google_project_service.agent_project]
}

resource "google_dialogflow_agent" "full_agent" {
  project = data.google_project.agent_project.project_id
  display_name = var.bot_name
  default_language_code = "en"
  supported_language_codes = ["fr","es"]
  time_zone = "America/Chicago"
  description = "This is the ${var.bot_name} chat bot."
  avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_logging = true
  match_mode = "MATCH_MODE_ML_ONLY"
  classification_threshold = 0.3
  api_version = "API_VERSION_V2_BETA_1"
  tier = "TIER_STANDARD"
  #match_mode = "MATCH_MODE_HYBRID"
  #classification_threshold = 0.7
  #api_version = "API_VERSION_V2"
  #tier = "TIER_ENTERPRISE"
  depends_on = [google_project_iam_member.agent_create]
}

resource "null_resource" "import" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    #command = "curl -X POST -H \"Authorization: Bearer \"$(gcloud auth application-default print-access-token) -H \"Content-Type: application/json; charset=utf-8\" https://dialogflow.googleapis.com/v2/projects/bhood-214523/agent:import --data '{ \"agentUri\": \"gs://${data.google_project.agent_project.project_id}.appspot.com/CWOWBot.zip\" }'"
    #command = "curl -X POST -H \"Authorization: Bearer \"$(gcloud auth application-default print-access-token) -H \"Content-Type: application/json; charset=utf-8\" https://dialogflow.googleapis.com/v2/projects/${data.google_project.agent_project.project_id}/agent:import --data '${data.template_file.import_request.rendered}'"
    #command = "curl -X POST -H \"Authorization: Bearer \"$(gcloud auth application-default print-access-token) -H \"Content-Type: application/json; charset=utf-8\" https://dialogflow.googleapis.com/v2/projects/${data.google_project.agent_project.project_id}/agent:import --data '{ \"agentContent\": \"${filebase64(data.archive_file.bot_zip.output_path}\" }'"
    
    command = "rm -f ${local.zip_filename};cd ${var.bot_name};zip -r ../${local.zip_filename} .;cd .. ;curl -X POST -H \"Authorization: Bearer \"$(gcloud auth application-default print-access-token) -H \"Content-Type: application/json; charset=utf-8\" https://dialogflow.googleapis.com/v2/projects/${data.google_project.agent_project.project_id}/agent:import --data '{ \"agentContent\": \"${filebase64(local.zip_filename)}\"}'"
  }
  depends_on = [google_dialogflow_agent.full_agent]
}
