output "alb_url" {
  value = "http://${aws_lb.app.dns_name}"
}

output "ingest_url_example" {
  value = "http://${aws_lb.app.dns_name}/ingest"
}

output "dynamodb_table" {
  value = aws_dynamodb_table.events.name
}

output "lambda_function_name" {
  value = aws_lambda_function.response.function_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.repo.repository_url
}