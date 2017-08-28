output "ecr_repo_idbroker" {
  value = "${module.ecr_idbroker.repo_url}"
}

output "ecr_repo_emailservice" {
  value = "${module.ecr_emailservice.repo_url}"
}

output "ecr_repo_pwapi" {
  value = "${module.ecr_pwapi.repo_url}"
}

output "ecr_repo_simplesamlphp" {
  value = "${module.ecr_simplesamlphp.repo_url}"
}

output "ecr_repo_idsync" {
  value = "${module.ecr_idsync.repo_url}"
}

output "ecr_repo_dbbackup" {
  value = "${module.ecr_dbbackup.repo_url}"
}
