# ----------------------
# FILE: rds.tf
# ----------------------

resource "aws_security_group" "rds_sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.public[*].id  # You can switch to private if needed
}

resource "aws_db_instance" "medusa_postgres" {
  identifier             = "medusa-postgres-db"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "13.20"
  instance_class         = "db.t3.micro"
  db_name                = "medusa"
  username               = "medusadbuser"
  password               = "admin717"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
}
