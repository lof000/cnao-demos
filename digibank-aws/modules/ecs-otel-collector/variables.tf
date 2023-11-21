variable "app_count" {
  type = number
  default = 1
}

variable "aws_demo_tag_env" {
  type = string
  default =  "xxx-dev"
}

variable "aws_demo_tag_owner" {
  type = string
  default =  "xxx"
}

variable "aws_profile" {
  type = string
  default =  "default"
}

variable "aws_account" {
  type = string
  default =  "xxx"
}

variable "aws_cloudwatch_region" {
  type = string
  default =  "us-xxx-1"
}

variable "ecs_cluster_name" {
  type = string
  default =  "payments_cluster"
}

variable "CNAO_TENANT_HOST" {
  type = string
  default =  "-"
}
variable "CNAO_CLIENT_ID" {
  type = string
  default =  "-"
}
variable "CNAO_CLIENT_SECRET" {
  type = string
  default =  "-"
}
variable "CNAO_TOKEN_URL" {
  type = string
  default =  "-"
}

