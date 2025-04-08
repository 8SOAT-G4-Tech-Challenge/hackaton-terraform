resource "aws_sqs_queue" "converter_queue_deadletter" {
  name = "${var.environment}-${var.project_name}-deadletter-queue"
}

resource "aws_sqs_queue" "converter_queue" {
  name                       = "${var.environment}-${var.project_name}-converter-queue"
  delay_seconds              = 5
  max_message_size           = 262144
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 10
  visibility_timeout_seconds = 300


  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.converter_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}


resource "aws_sqs_queue_redrive_allow_policy" "deadletter_policy" {
  queue_url = aws_sqs_queue.converter_queue_deadletter.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns   = [aws_sqs_queue.converter_queue.arn]
  })
}
