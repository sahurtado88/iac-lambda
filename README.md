🚀 Instrucciones de Setup Completo
📋 Prerrequisitos
AWS CLI configurado con credenciales

Terraform >= 1.0 instalado

Docker instalado

GitHub account con repositorios

Python 3.11 para desarrollo local

🔧 Setup Paso a Paso
1. Crear los Repositorios
# Crear repo 1: Aplicación Lambda
mkdir lambda-app-repo
cd lambda-app-repo
git init
# Copiar archivos del repo de aplicación aquí

# Crear repo 2: Infraestructura
mkdir lambda-iac-repo
cd lambda-iac-repo
git init
# Copiar archivos del repo de infraestructura aquí
2. Configurar AWS Backend para Terraform (Opcional pero recomendado)
# Crear bucket para Terraform state
aws s3 mb s3://my-terraform-state-bucket-$(date +%s)

# Crear tabla DynamoDB para locks
aws dynamodb create-table \
    --table-name terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
3. Configurar Secrets en GitHub
Para ambos repositorios, agregar estos secrets en Settings > Secrets and variables > Actions:

AWS_ACCESS_KEY_ID: Tu AWS Access Key

AWS_SECRET_ACCESS_KEY: Tu AWS Secret Key

4. Setup del Repo de Aplicación (lambda-app-repo)
cd lambda-app-repo

# Crear estructura de archivos
mkdir -p src tests .github/workflows

# Copiar archivos (usar los archivos creados anteriormente)
# - src/lambda_function.py
# - tests/test_lambda_function.py
# - Dockerfile
# - requirements.txt
# - .github/workflows/build-and-push.yml

# Configurar git
git add .
git commit -m "Initial Lambda application setup"
git branch -M main
git remote add origin https://github.com/tu-usuario/lambda-app-repo.git
git push -u origin main
5. Setup del Repo de Infraestructura (lambda-iac-repo)
cd lambda-iac-repo

# Crear estructura
mkdir -p .github/workflows

# Copiar archivos de Terraform
# - main.tf
# - variables.tf
# - outputs.tf
# - terraform.tfvars.example
# - .github/workflows/terraform.yml

# Configurar terraform.tfvars
cp terraform.tfvars.example terraform.tfvars

# Editar terraform.tfvars con tus valores

# Si usas S3 backend, descomentar en main.tf:
# backend "s3" {
#   bucket = "tu-bucket-name"
#   key    = "lambda-app/terraform.tfstate"
#   region = "us-east-1"
#   dynamodb_table = "terraform-locks"
#   encrypt = true
# }

# Configurar git
git add .
git commit -m "Initial Terraform infrastructure setup"
git branch -M main
git remote add origin https://github.com/tu-usuario/lambda-iac-repo.git
git push -u origin main

6. Primer Deployment
Paso 1: Deploy de Infraestructura (crear ECR)
cd lambda-iac-repo

# Inicializar Terraform
terraform init

# Crear solo el ECR primero (comentar temporalmente el lambda en main.tf)
terraform plan
terraform apply

Paso 2: Build y Push de la Aplicación
cd lambda-app-repo

# Push a main para activar el pipeline
git push origin main

# Esto ejecutará:
# 1. Tests
# 2. Build de imagen Docker
# 3. Push a ECR
# 4. Actualización de SSM parameter
Paso 3: Deploy completo de infraestructura
cd lambda-iac-repo

# Descomentar el recurso lambda en main.tf
# Hacer commit y push para activar pipeline de Terraform
git add .
git commit -m "Enable Lambda function deployment"
git push origin main
🧪 Testing
Test Local de la Lambda
cd lambda-app-repo

# Instalar dependencias
pip install -r requirements.txt
pip install pytest

# Ejecutar tests
pytest tests/ -v

# Test manual
python -c "
from src.lambda_function import lambda_handler
event = {'name': 'Test', 'action': 'greet'}
result = lambda_handler(event, {})
print(result)
"
Test con Docker Local
cd lambda-app-repo

# Build imagen
docker build -t my-lambda-test .

# Ejecutar localmente
docker run --rm -p 9000:8080 my-lambda-test

# En otra terminal, hacer request
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" \
  -d '{"name": "Docker", "action": "greet"}'
Test en AWS (después del deployment)
# Obtener la Function URL desde Terraform output
cd lambda-iac-repo
terraform output lambda_function_url

# Hacer request a la Lambda
curl -X POST "https://tu-function-url.lambda-url.us-east-1.on.aws/" \
  -H "Content-Type: application/json" \
  -d '{"name": "AWS", "action": "greet"}'
🔄 Flujo de Desarrollo
Para cambios en la aplicación:
Modificar código en lambda-app-repo

Ejecutar tests localmente

Push a develop para testing

Push a main para producción

Para cambios en infraestructura:
Modificar archivos .tf en lambda-iac-repo

Ejecutar terraform plan localmente

Push para activar pipeline de Terraform

🛡️ Mejores Prácticas de Seguridad
1. IAM Roles Mínimos
Lambda solo tiene permisos para logs y SSM

CI/CD tiene permisos específicos para ECR y Terraform

2. Encriptación
ECR con encriptación AES256

S3 backend con encriptación

Logs de CloudWatch encriptados

3. Versionado
Imágenes taggeadas con commit SHA

Lifecycle policies en ECR

State locking con DynamoDB

4. Monitoreo
CloudWatch logs automáticos

Métricas de Lambda

Alertas opcionales (agregar CloudWatch Alarms)

🚨 Troubleshooting
Error: "SSM parameter not found"
# Crear manualmente el parámetro SSM
aws ssm put-parameter \
  --name "/lambda/my-app/dev/image-uri" \
  --value "placeholder" \
  --type "String"
Error: "ECR repository not found"
# Verificar que el ECR existe
aws ecr describe-repositories --repository-names my-lambda-app
Error: "Terraform state locked"
# Forzar unlock (usar con cuidado)
terraform force-unlock LOCK_ID
📚 Próximos Pasos
Agregar API Gateway para endpoints REST

Implementar CloudWatch Alarms para monitoreo

Agregar tests de integración con AWS

Configurar múltiples ambientes (dev/staging/prod)

Implementar blue/green deployments