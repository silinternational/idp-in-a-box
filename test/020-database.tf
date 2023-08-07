module "default_database" {
  source = "../terraform/020-database"

  app_env           = "test"
  app_name          = "test"
  mysql_user        = "root"
  db_name           = "db"
  security_groups   = ["sg-12345"]
  subnet_group_name = "db-subnet-test"
}

module "read-replica" {
  source = "../terraform/020-database"

  app_env           = "test"
  app_name          = "test"
  mysql_user        = "root"
  db_name           = "db"
  security_groups   = ["sg-12345"]
  subnet_group_name = "db-subnet-test"

  create_passwords    = false
  replicate_source_db = "arn:aws:rds:us-east-1:123456789012:db:dummy"
}

module "all_inputs" {
  source = "../terraform/020-database"

  app_env                 = ""
  allocated_storage       = ""
  app_name                = ""
  availability_zone       = ""
  backup_retention_period = ""
  create_passwords        = true
  db_name                 = ""
  engine                  = ""
  engine_version          = ""
  instance_class          = ""
  multi_az                = ""
  mysql_user              = ""
  replicate_source_db     = ""
  security_groups         = [""]
  skip_final_snapshot     = ""
  storage_type            = ""
  subnet_group_name       = ""
}
