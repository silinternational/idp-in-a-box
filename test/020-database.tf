module "default_database" {
  source = "../terraform/020-database"

  app_env           = "test"
  app_name          = "test"
  mysql_user        = "root"
  db_name           = "db"
  security_groups   = ["sg-12345"]
  subnet_group_name = "db-subnet-test"
}
