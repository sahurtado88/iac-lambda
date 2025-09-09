output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.lambda_repo.repository_url
}

output "ecr_repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.lambda_repo.arn
}

#output "lambda_function_name" {
#  description = "Name of the Lambda function"
#  value       = aws_lambda_function.main.function_name
#}
#
#output "lambda_function_arn" {
#  description = "ARN of the Lambda function"
#  value       = aws_lambda_function.main.arn
#}
#
#output "lambda_function_url" {
#  description = "URL of the Lambda function (if created)"
#  value       = var.create_function_url ? aws_lambda_function_url.main[0].function_url : null
#}
#
#output "lambda_role_arn" {
#  description = "ARN of the Lambda execution role"
#  value       = aws_iam_role.lambda_role.arn
#}
#
#output "cloudwatch_log_group_name" {
#  description = "Name of the CloudWatch log group"
#  value       = aws_cloudwatch_log_group.lambda_logs.name
#}
#
#output "ssm_parameter_name" {
#  description = "Name of the SSM parameter storing the image URI"
#  value       = "/lambda/${var.project_name}/${var.environment}/image-uri"
#}