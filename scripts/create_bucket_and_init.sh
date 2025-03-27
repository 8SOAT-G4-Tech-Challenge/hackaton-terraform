BUCKET_NAME="$1-hackaton-g4-terraform-state"
REGION="us-east-1"

# Verifica se o bucket S3 já existe
if aws s3 ls "s3://$BUCKET_NAME" 2>&1 | grep -q 'NoSuchBucket'; then
  echo "Bucket S3 não encontrado. Criando o bucket..."
  
  # Cria o bucket S3
  aws s3 mb s3://$BUCKET_NAME --region $REGION
  
  # Verifica se o bucket foi criado com sucesso
  if [ $? -eq 0 ]; then
    echo "Bucket S3 '$BUCKET_NAME' criado com sucesso."
  else
    echo "Erro ao criar o bucket S3. Abortando."
    exit 1
  fi
else
  echo "Bucket S3 '$BUCKET_NAME' já existe."
fi

# Executa o terraform init
echo "Iniciando o Terraform..."
terraform init