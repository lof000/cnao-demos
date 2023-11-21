

data "aws_availability_zones" "available_zones" {
  state = "available"
}

resource "aws_vpc" "collector" {
  cidr_block = "10.32.0.0/16"
}

resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.collector.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.collector.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "colprivate" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.collector.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.collector.id
}

resource "aws_internet_gateway" "colgateway" {
  vpc_id = aws_vpc.collector.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.collector.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.colgateway.id
}

resource "aws_eip" "colgateway" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.colgateway]
}

resource "aws_nat_gateway" "colgateway" {
  count         = 2
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.colgateway.*.id, count.index)
}

resource "aws_route_table" "colprivate" {
  count  = 2
  vpc_id = aws_vpc.collector.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.colgateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "colprivate" {
  count          = 2
  subnet_id      = element(aws_subnet.colprivate.*.id, count.index)
  route_table_id = element(aws_route_table.colprivate.*.id, count.index)
}

resource "aws_security_group" "colsecgroup" {
  name        = "collector-alb-security-group"
  vpc_id      = aws_vpc.collector.id

  ingress {
    protocol    = "tcp"
    from_port   = 4318
    to_port     = 4318
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    demoenv = "${var.aws_demo_tag_env}",
    demoowner = "${var.aws_demo_tag_owner}"
  }
}

resource "aws_lb" "albcollector" {
  name            = "otel-collector-lb-col"
  subnets         = aws_subnet.public.*.id
  security_groups = [aws_security_group.colsecgroup.id]

  tags = {
    demoenv = "${var.aws_demo_tag_env}",
    demoowner = "${var.aws_demo_tag_owner}"
  }

}

resource "aws_lb_target_group" "collector-2" {
  name        = "collector-tg-ec-2"
  port        = 4318
  protocol    = "HTTP"
  vpc_id      = aws_vpc.collector.id
  target_type = "ip"
  health_check {
    enabled = true
    path = "/"
    port= "13133"
    interval = 120
    timeout = 60
    unhealthy_threshold = 10
  }
}

resource "aws_lb_listener" "collector-port2" {
  load_balancer_arn = aws_lb.albcollector.id
  port              = "4318"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.collector-2.id
    type             = "forward"
  }
}

resource "aws_cloudwatch_log_group" "collectorloggrp" {
  name = "collectorlg"

}

resource "aws_ecs_task_definition" "collector" {
  family                   = "collector-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 3072
  execution_role_arn = "arn:aws:iam::${var.aws_account}:role/ecsTaskExecutionRole"
  task_role_arn = "arn:aws:iam::${var.aws_account}:role/ecsTaskExecutionRole"

  tags = {
    demoenv = "${var.aws_demo_tag_env}",
    demoowner = "${var.aws_demo_tag_owner}"
  }

  container_definitions = <<DEFINITION
[
    {
        "Name": "collector-app",
        "Image": "leandrovo/otel-contrib:gdl",
        "Essential": true,
        "memory": 512,
        "portMappings": [
                {
                    "name": "col_1",
                    "containerPort": 4317,
                    "hostPort": 4317,
                    "protocol": "tcp",
                    "appProtocol": "http"
                },
              {
                    "name": "col_2",
                    "containerPort": 4318,
                    "hostPort": 4318,
                    "protocol": "tcp",
                    "appProtocol": "http"
                },
              {
                    "name": "hcheck",
                    "containerPort": 13133,
                    "hostPort": 13133,
                    "protocol": "tcp",
                    "appProtocol": "http"
                }                              
        ],
        "environment": [
            {
                "name": "CNAO_TENANT_HOST",
                "value": "${var.CNAO_TENANT_HOST}"
            },
            {
                "name": "CNAO_CLIENT_ID",
                "value": "${var.CNAO_CLIENT_ID}"
            },
            {
                "name": "CNAO_CLIENT_SECRET",
                "value": "${var.CNAO_CLIENT_SECRET}"
            },
            {
                "name": "CNAO_TOKEN_URL",
                "value": "${var.CNAO_TOKEN_URL}"
            }
        ],        
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-create-group": "True",
                "awslogs-group": "collectorlg",
                "awslogs-region": "${var.aws_cloudwatch_region}",
                "awslogs-stream-prefix": "ecs"
            }
        }        

    } 

]
DEFINITION

}

resource "aws_security_group" "collector_task" {
  name        = "collector-task-security-group"
  vpc_id      = aws_vpc.collector.id

  ingress {
    protocol        = "tcp"
    from_port       = 4318
    to_port         = 4318
    security_groups = [aws_security_group.colsecgroup.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "colmain" {
  name = "${var.ecs_cluster_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    demoenv = "${var.aws_demo_tag_env}",
    demoowner = "${var.aws_demo_tag_owner}"
  }
  
}

resource "aws_ecs_service" "collector" {
  name            = "collector-service"
  cluster         = aws_ecs_cluster.colmain.id
  task_definition = aws_ecs_task_definition.collector.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.collector_task.id]
    subnets         = aws_subnet.colprivate.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.collector-2.id
    container_name   = "collector-app"
    container_port   = 4318
  }

  depends_on = [aws_lb_listener.collector-port2]


}


