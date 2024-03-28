provider "aws" {
  region = "ap-south-1"
}

resource "aws_db_instance" "my_mysql_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = "my-rds-instance"
  name                 = "mydb"
  username             = "<username>"
  password             = "<password>"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible  = true
  vpc_security_group_ids = ["<security group id>"]
  db_subnet_group_name = "my-db-subnet-group"
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = ["subnet-1", "subnet-2"]
}

resource "aws_security_group" "my_rds_sg" {
  name        = "my-rds-sg"
  description = "Security group for RDS DB Instance"
  vpc_id      = "vpc-xxxxxxxxxxxx"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
