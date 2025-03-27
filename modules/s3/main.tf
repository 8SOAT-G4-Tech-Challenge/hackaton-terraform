#Criação do bucket principal
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.environment}-${var.project_name}-g4-bucket"

  tags = {
    Name        = "${var.project_name}"
    Environment = "${var.environment}"
  }
}
