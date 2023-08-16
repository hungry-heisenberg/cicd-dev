/* resource "aws_ecs_service" "imported_service" {
  name            = "ecs-svc"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = data.aws_ecs_task_definition.my_task_definition
  launch_type     = "EC2" # Or "FARGATE" if applicable
  desired_count   = 1

  # Other ECS service settings
}

resource "aws_ecs_cluster" "my_cluster" {
   name = "LNProject"
}

data "aws_ecs_task_definition" "my_task_definition" {
  task_definition = "arn:aws:ecs:us-west-2:971760914448:task-definition/WebService:9" # Replace with your task definition ARN
} */