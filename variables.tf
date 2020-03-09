variable "bot_api_version" {
  type        = string
  description = "DialogFlow bot api_version (API_VERSION_V2)"
  default     = "API_VERSION_V2_BETA_1"
}

variable "bot_avatar_uri" {
  type        = string
  description = "DialogFlow bot avatar uri"
  default     = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
}

variable "bot_classification_threshold" {
  type        = number
  description = "DialogFlow bot classification_threshold"
  default     =  0.3
}

variable "bot_match_mode" {
  type        = string
  description = "bot_match_mode: MATCH_MODE_ML_ONLY|MATCH_MODE_HYBRID"
  default     = "MATCH_MODE_ML_ONLY"
}

variable "bot_name" {
  type        = string
  description = "DialogFlow bot name"
  default     = "sre"
}

variable "bot_tier" {
  type        = string
  description = "DialogFlow bot tier:  TIER_STANDARD|TIER_ENTERPRISE"
  default     = "TIER_STANDARD"
 }

variable "cf_entry_point" {
  type        = string
  description = "Entrypoint of the cloud function"
  default     = "app"
}

variable "cf_max_concurrency" {
  type        = string
  description = "Maximum number of concurrent function instances that can be run"
  default     = 3
}

variable "cf_memory_size_mb" {
  type        = string
  description = "Memory of the cloud function in MB" 
  default     = 128
}

variable "cf_runtime" {
  type        = string
  description = "Runtime environment for the cloud function"  
  default     = "nodejs8"
}

variable "cf_timeout" {
  type        = number
  description = "Maximum amount of time your cloud function can run in seconds"  
  default     = 60
}

variable "description" {
  type        = string
  description = "Short description"
  default     = "This is a SRE chat bot"
}

variable "location" {
  type        = string
  description = "Location (region or zone) for resources"
  default     = "us-central1"
}

variable "project" {
  type        = string
  description = "Project where DialogFlow bot and fulfillment Cloud Function are deployed"
  default     = "bhood-214523"
}
