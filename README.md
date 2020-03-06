# srebot
SRE bot uses terraform to deploy GCP DialogFlow bot for Site Reliability Engineers who are lonely

## Pre-requisites for deploying from local machine
* Install terraform locally.
* Create an GCP account and project. 
* https://dialogflow.cloud.google.com/ login and enable
* Setup authentication to your GCP account in account.json (don't check this in)
* export GOOGLE_APPLICATION_CREDENTIALS=account.json
* update your project and bot_name in in variables.tf

## Instructions for deploying from local machine
```
terraform init
terraform plan 
terraform apply
```
## Importing agent
Terraform DialogFlow support in the google provider is currently restricted to the top level "google_dialogflow_agent" resource.
The agent configuration, including Entities, Intents, and other agent configuration is managed using DialogFlow import/export zip.
The contents of the zip are unzipped to the sre_template directory, and templatized with ${XXX} variable references, and template_dir resource is used to render the entire sre_template directory to the sre directory.
A null_resource local provisioner zips up the rendered sre directory and calls the DialogFlow import API to configure the agent.

## refs
* https://github.com/terraform-providers/terraform-provider-google-beta
* https://medium.com/google-cloud/deconstructing-chatbots-getting-started-with-dialogflow-4f91deb32135
* https://github.com/actions-on-google/dialogflow-facts-about-google-nodejs
* https://dialogflow.cloud.google.com/#/login
* https://www.terraform.io/docs/providers/google/r/dialogflow_agent.html
* https://github.com/terraform-providers/terraform-provider-google
* https://cloud.google.com/dialogflow/docs/reference/rest/v2/projects.agent/import
* https://github.com/Mastercard/terraform-provider-restapi
