resource "aws_ecs_cluster" "lnp_aws_ecs_cluster" {
  name = "LNProject"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_role" "ecs_taskexecution_role" {
  name = "ecs_taskexecution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

/* resource "aws_iam_policy_attachment" "attach_policy" {
  name       = "AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_taskexecution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
} */

resource "aws_iam_role_policy_attachment" "attach_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_taskexecution_role.name
}

##
resource "aws_ecs_task_definition" "lnp_aws_ecs_task_definition" {
  family                   = "WebService"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  #execution_role_arn = var.ecs_iam_role
  execution_role_arn = aws_iam_role.ecs_taskexecution_role.arn
  container_definitions = jsonencode([
    {
      name      = "webserver"
      image     = aws_ecr_repository.lnp_aws_ecr_repository.repository_url
      cpu       = 1024
      memory    = 2048
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
  cpu    = 4096
  memory = 8192

  ephemeral_storage {
    size_in_gib = 21
  }

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  /* volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  } */
}
##
resource "aws_security_group" "lnp_ecs_webapp_sg" {
  name        = "lnp_ecs_webapp_sg"
  description = "Allow needed ports like ssh, http, https etc"
  vpc_id      = aws_vpc.lnp_aws_vpc.id

  ingress {
    description      = "Webapp access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "ecswebapp-securityGroupId" {
  value = aws_security_group.lnp_ecs_webapp_sg.id
}

##

resource "aws_ecs_service" "my_service" {
  name                    = "my-ecs-service"
  cluster                 = aws_ecs_cluster.lnp_aws_ecs_cluster.id
  task_definition         = aws_ecs_task_definition.lnp_aws_ecs_task_definition.arn
  launch_type             = "FARGATE"
  desired_count           = 2 # Number of tasks to run
  platform_version        = "LATEST"
  enable_ecs_managed_tags = true
  force_new_deployment    = true

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = ["${aws_subnet.lnp_aws_subnet.id}", "${aws_subnet.lnp_aws_subnet2.id}"]
    security_groups  = ["${aws_security_group.lnp_ecs_webapp_sg.id}"]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "my_service2" {
  name                    = "ecs-svc"
  cluster                 = aws_ecs_cluster.lnp_aws_ecs_cluster.id
  task_definition         = aws_ecs_task_definition.lnp_aws_ecs_task_definition.arn
  launch_type             = "FARGATE"
  desired_count           = 2 # Number of tasks to run
  platform_version        = "LATEST"
  enable_ecs_managed_tags = true
  force_new_deployment    = true


  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }
  /* Create Load balancer manually for this step */
  load_balancer {
    container_name   = "webserver"
    container_port   = 8080
    target_group_arn = "arn:aws:elasticloadbalancing:us-west-2:971760914448:targetgroup/lnp-lb-sg/58adecc9036c31d6"
  }

  network_configuration {
    subnets          = ["${aws_subnet.lnp_aws_subnet.id}", "${aws_subnet.lnp_aws_subnet2.id}"]
    security_groups  = ["${aws_security_group.lnp_ecs_webapp_sg.id}"]
    assign_public_ip = true
  }
}

