variable "bot_name" {
  type = string
  description = "DialogFlow bot name"
  default = "sre"
}

variable "project" {
  type = string
  description = "Project where DialogFlow bot and fulfillment Cloud Function are deployed"
  default = "bhood-214523"
}

variable "description" {
  type        = "string"
  description = "Short description"
  default     = "This is a SRE chat bot"
}

variable "location" {
  type        = "string"
  description = "Location (region or zone) for resources"
  default     = "us-central1"
}

variable "cf_runtime" {
  type        = "string"
  description = "Runtime environment for the cloud function"  
  default     = "nodejs8"
}

variable "cf_entry_point" {
  type        = "string"
  description = "Entrypoint of the cloud function"
  default     = "app"
}

variable "cf_memory_size_mb" {
  type        = "string"
  description = "Memory of the cloud function in MB" 
  default     = 128
}

variable "cf_timeout" {
  type        = "string"
  description = "Maximum amount of time your cloud function can run in seconds"  
  default     = 60
}

variable "cf_max_concurrency" {
  type        = "string"
  description = "Maximum number of concurrent function instances that can be run"
  default     = 3
}
