# srebot
SRE bot uses terraform to deploy GCP DialogFlow bot for Site Reliability Engineers who are lonely

## Pre-requisites for deploying from local machine
* Install terraform locally.
* Create an GCP account. 
* Setup authentication to your GCP account in account.json (don't check this in)
* update your project_id in provider.tf
* https://dialogflow.cloud.google.com/ login and enable

## Instructions for deploying from local machine
```
Initialize terraform:
terraform init
terraform plan 
terraform apply
```

## refs
* https://github.com/terraform-providers/terraform-provider-google-beta
* https://medium.com/google-cloud/deconstructing-chatbots-getting-started-with-dialogflow-4f91deb32135
* https://github.com/actions-on-google/dialogflow-facts-about-google-nodejs
* https://dialogflow.cloud.google.com/#/login
* https://www.terraform.io/docs/providers/google/r/dialogflow_agent.html
* https://github.com/terraform-providers/terraform-provider-google
* https://cloud.google.com/dialogflow/docs/reference/rest/v2/projects.agent/import
* https://github.com/Mastercard/terraform-provider-restapi
