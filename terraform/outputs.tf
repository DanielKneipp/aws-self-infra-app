output "app_infra_manager_secret_access_key" {
  value     = aws_iam_access_key.app_infra_manager.secret
  sensitive = true
}

output "app_infra_manager_access_key" {
  value = aws_iam_access_key.app_infra_manager.id
}

output "gh_role_arn" {
  value = aws_iam_role.github.arn
}
