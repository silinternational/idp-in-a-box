module "defaults" {
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
