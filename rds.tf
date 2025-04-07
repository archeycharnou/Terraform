
#####################################
# IAM ROLE FOR ACCESSING PRIVATE S3
#####################################

resource "aws_db_subnet_group" "rds_subnetgroup" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "db" {
  identifier             = "mydb-instance"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "Username"
  password               = "Password"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "MySQL RDS instance"
  }
}
