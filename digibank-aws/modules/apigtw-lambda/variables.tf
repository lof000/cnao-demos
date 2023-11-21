
variable "aws_demo_tag_env" {
  type = string
  default =  "xx-xx"
}

variable "aws_demo_tag_owner" {
  type = string
  default =  "xx"
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

variable "otel_layer" {
  description = "OTEL agent layer ARN"

  type    = string
  default = "arn:aws:lambda:us-east-1:184161586896:layer:opentelemetry-nodejs-0_2_0:1"

}

variable "otel_otlp_endpoint" {
  description = "OTEL agent layer ARN"

  type    = string
  default = "http://localhost:4318"
  
}

