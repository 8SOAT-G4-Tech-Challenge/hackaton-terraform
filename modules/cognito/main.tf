# Criação da User Pool (Diretório de usuários que armazena credenciais e gerencia a autenticação)
resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = "${var.environment}-${var.project_name}-user-pool"

  # Caso queira confirmar email ou número de telefone
  auto_verified_attributes = []
  mfa_configuration        = "OFF"

  schema {
    name                = "id"
    attribute_data_type = "String"
    mutable             = true
    required            = false
  }

  schema {
    name                = "email"
    attribute_data_type = "String"
    mutable             = true
    required            = true
    string_attribute_constraints {
      min_length = 0
      max_length = 150
    }
  }

  schema {
    name                = "phone_number"
    attribute_data_type = "String"
    mutable             = true
    required            = true
    string_attribute_constraints {
      min_length = 0
      max_length = 14
    }
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  tags = {
    Name = "${var.environment}-${var.project_name}-user-pool"
    Iac  = true
  }
}

# Criação do App Client
resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  name                                 = "${var.environment}-${var.project_name}-user-pool-client"
  user_pool_id                         = aws_cognito_user_pool.cognito_user_pool.id
  callback_urls                        = ["https://example.com"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email", "openid", "aws.cognito.signin.user.admin"]
  supported_identity_providers         = ["COGNITO"]

  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  generate_secret = false
}

# Criação de um subdomínio de autenticação
resource "aws_cognito_user_pool_domain" "subdomain" {
  domain       = "${var.environment}-${var.project_name}-auth"
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
}

# # Criação do usuário Admin
# resource "aws_cognito_user" "admin_user" {
#   user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
#   username     = var.admin_user_email

#   attributes = {
#     email          = var.admin_user_email
#     email_verified = "true"
#     phone_number   = var.admin_phone_number
#   }

#   password = var.admin_user_password
# }

# Criação do grupo de usuário Admin
resource "aws_cognito_user_group" "admin_group" {
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
  name         = "admin"
  description  = "Administrators group"
}

# # Associar usuário Admin ao grupo Admin
# resource "aws_cognito_user_in_group" "admin_user_in_group" {
#   user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
#   username     = aws_cognito_user.admin_user.username
#   group_name   = aws_cognito_user_group.admin_group.name
# }

# Criar secret para armazenar o client ID no Systems Manager
resource "aws_secretsmanager_secret" "cognito_secret" {
  name = "cognito-client-id"
}

# Armazenar o client ID no Systems Manager
resource "aws_secretsmanager_secret_version" "cognito_secret_version" {
  secret_id     = aws_secretsmanager_secret.cognito_secret.id
  secret_string = aws_cognito_user_pool_client.cognito_user_pool_client.id
}
