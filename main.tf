data "google_project" "agent_project" {
}

data "archive_file" "bot_zip" {
  type        = "zip"
  source_dir  = "${path.module}/${var.bot_name}"
  output_path = "${path.module}/${var.bot_name}.zip"
}

data "template_file" "import_request" {
  template = "{ \"agentContent\": \"$${zip_content}\" }"
  vars = {
    zip_content = "${filebase64(data.archive_file.bot_zip.output_path)}"
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
    #command = "export GOOGLE_APPLICATION_CREDENTIALS=account.json | curl -X POST -H \"Authorization: Bearer \"$(gcloud auth application-default print-access-token) -H \"Content-Type: application/json; charset=utf-8\" https://dialogflow.googleapis.com/v2/projects/bhood-214523/agent:import --data '{ \"agentUri\": \"gs://${data.google_project.agent_project.project_id}.appspot.com/CWOWBot.zip\" }'"
    command = "export GOOGLE_APPLICATION_CREDENTIALS=account.json | curl -X POST -H \"Authorization: Bearer \"$(gcloud auth application-default print-access-token) -H \"Content-Type: application/json; charset=utf-8\" https://dialogflow.googleapis.com/v2/projects/${data.google_project.agent_project.project_id}/agent:import --data '${data.template_file.import_request.rendered}'"
  }
  depends_on = [google_dialogflow_agent.full_agent]
}
