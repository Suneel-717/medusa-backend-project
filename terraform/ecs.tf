# ----------------------
# FILE: ecs.tf
# ----------------------

resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "medusa"
      image     = "${aws_ecr_repository.medusa_repo.repository_url}:latest"
      essential = true
      portMappings = [{
        containerPort = 9000
        protocol      = "tcp"
      }]
      environment = [
        {
          name  = "REDIS_URL"
          value = "redis://ridus-cache-anzzch.serverless.use1.cache.amazonaws.com:6379"
        },
        {
          name  = "JWT_SECRET"
          value = "48e68eedb54849459dc126e50812f17a"
        },
        {
          name  = "COOKIE_SECRET"
          value = "2c64343c97ca4d70bf94e152eb299b80"
        },
        {
          name  = "DATABASE_URL"
          value = "postgres://admin:admin717@medusadb.co9s80gqefz6.us-east-1.rds.amazonaws.com:5432/medusa?ssl=true&sslmode=require&rejectUnauthorized=false"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    assign_public_ip = true
    security_groups  = [aws_security_group.allow_http.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.medusa_tg.arn
    container_name   = "medusa"
    container_port   = 9000
  }

  depends_on = [
    aws_lb_listener.medusa_listener
  ]
}
