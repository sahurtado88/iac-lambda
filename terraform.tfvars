# Copia este archivo a terraform.tfvars y ajusta los valores

aws_region            = "us-east-1"
environment          = "prod"
project_name         = "my-app"
ecr_repository_name  = "my-lambda-app"
lambda_function_name = "my-lambda-function-prod"
lambda_timeout       = 30
lambda_memory_size   = 256
log_retention_days   = 14
app_version         = "1.0.0"
log_level           = "INFO"
create_function_url = true

