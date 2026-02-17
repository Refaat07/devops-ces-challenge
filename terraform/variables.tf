variable "env_name" {
  type = string
  description = "Resouce name prefix for the environment"
  default     = "dv"
}
variable "region" {
  type = string
  description = "Default Region for AWS resources"
  default     = "eu-central-1"
}
variable "oauth2_issuer_url" {
  type        = string
  description = "OAuth2 Issuer URL"
  default     = "https://token.actions.githubusercontent.com"
}

variable "authorization_url" {
  type        = string
  description = "OAuth2 Authorization URL"
  default     = "https://github.com/login/oauth/authorize"
}

variable "token_url" {
  type        = string
  description = "OAuth2 Token URL"
  default     = "https://github.com/login/oauth/access_token"
}

variable "user_info_endpoint" {
  type        = string
  description = "OAuth2 User Info Endpoint"
  default     = "https://api.github.com/user"
}

variable "client_id" {
  type        = string
  description = "OAuth2 Client ID"
  sensitive   = true
}