variable "app_count" {
  type = number
  default = 1
}

variable "aws_demo_tag_env" {
  type = string
  default =  "xxx"
}

variable "aws_demo_tag_owner" {
  type = string
  default =  "xxx"
}

variable "aws_profile" {
  type = string
  default =  "xxxx"
}

variable "aws_account" {
  type = string
  default =  "xxx"
}

variable "aws_cloudwatch_region" {
  type = string
  default =  "xxxx"
}

variable "ecs_cluster_name" {
  type = string
  default =  "payments_cluster"
}

variable "OTEL_EXPORTER_OTLP_ENDPOINT" {
  type = string
  default =  "http://localhost:4317"
}

variable "OTEL_SERVICE_NAME" {
  type = string
  default =  "pix"
}

variable "OTEL_SERVICE_NAMESPACE" {
  type = string
  default =  "digibank-backends"
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

variable "ecs_api_cluster_name" {
  type = string
  default =  "payments_cluster"
}

variable "otel_layer" {
  description = "OTEL agent layer ARN"

  type    = string
  default = "arn:aws:lambda:us-east-1:184161586896:layer:opentelemetry-nodejs-0_2_0:1"

}

