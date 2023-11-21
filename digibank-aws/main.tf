

module "otel_collector" {
  source = "./modules/ecs-otel-collector"

  aws_profile = "${var.aws_profile}"
  aws_account = "${var.aws_account}"
  aws_cloudwatch_region = "${var.aws_cloudwatch_region}" 
  aws_demo_tag_env = "${var.aws_demo_tag_env}"
  aws_demo_tag_owner = "${var.aws_demo_tag_owner}"  
  ecs_cluster_name = "${var.ecs_cluster_name}"
  CNAO_TENANT_HOST = "${var.CNAO_TENANT_HOST}"
  CNAO_CLIENT_ID = "${var.CNAO_CLIENT_ID}"
  CNAO_CLIENT_SECRET = "${var.CNAO_CLIENT_SECRET}"
  CNAO_TOKEN_URL = "${var.CNAO_TOKEN_URL}"
}

module "ecs_api" {
  source = "./modules/alb-ecs-api"

  aws_profile = "${var.aws_profile}"
  aws_account = "${var.aws_account}"
  aws_cloudwatch_region = "${var.aws_cloudwatch_region}"
  aws_demo_tag_env = "${var.aws_demo_tag_env}"
  aws_demo_tag_owner = "${var.aws_demo_tag_owner}"
  ecs_api_cluster_name = "${var.ecs_api_cluster_name}"
  OTEL_SERVICE_NAME = "${var.OTEL_SERVICE_NAME}"
  OTEL_SERVICE_NAMESPACE = "${var.OTEL_SERVICE_NAMESPACE}"
  OTEL_EXPORTER_OTLP_ENDPOINT = "http://${module.otel_collector.load_balancer_ip}:4318"
  CNAO_TENANT_HOST = "${var.CNAO_TENANT_HOST}"
  CNAO_CLIENT_ID = "${var.CNAO_CLIENT_ID}"
  CNAO_CLIENT_SECRET = "${var.CNAO_CLIENT_SECRET}"
  CNAO_TOKEN_URL = "${var.CNAO_TOKEN_URL}"  

}

module "apigtw_lambda" {
  source = "./modules/apigtw-lambda"

  aws_profile = "${var.aws_profile}"
  aws_account = "${var.aws_account}"
  aws_cloudwatch_region = "${var.aws_cloudwatch_region}"
  aws_demo_tag_env = "${var.aws_demo_tag_env}"
  aws_demo_tag_owner = "${var.aws_demo_tag_owner}"  
  otel_layer = "${var.otel_layer}"
  otel_otlp_endpoint = "http://${module.otel_collector.load_balancer_ip}:4318"

}

module "digibank" {
  source = "./modules/digibank"

  region = "${var.aws_cloudwatch_region}"
  lambda_gtw_endpoint = "${module.apigtw_lambda.base_url}/confirmPayment?Name=Terraform"
  ecs_elb_endpoint = "${module.ecs_api.ecs_alb_api}"

}


module "digibank-load" {
  source = "./modules/load/load"

}

resource "null_resource" "otelinstrument" {
  provisioner "local-exec" {
    command = "./otel_instrument.sh"
  }
depends_on = [
    module.digibank
  ]
}
