# Criação da namespace
resource "kubernetes_namespace" "converter" {
  metadata {
    name = "${var.environment}-${var.project_name}-converter"
  }
}

# Criação do config map
resource "kubernetes_config_map" "converter_config_map" {
  metadata {
    name      = "${var.environment}-${var.project_name}-converter-config-map"
    namespace = kubernetes_namespace.converter.metadata[0].name
    labels = {
      name = "${var.environment}-${var.project_name}-converter-config-map"
    }
  }

  data = {
    API_PORT              = var.converter_port
    AWS_SQS_URL           = data.aws_sqs_queue.converter_queue.url
    AWS_REGION            = var.aws_region
    AWS_BUCKET            = data.aws_s3_bucket.bucket.bucket
    HACKATON_API_BASE_URL = var.api_url
  }
}

# Criação do service
resource "kubernetes_service" "converter_service" {
  metadata {
    name      = "${var.environment}-${var.project_name}-converter-service"
    namespace = kubernetes_namespace.converter.metadata[0].name
    labels = {
      name = "${var.environment}-${var.project_name}-converter-service"
    }
  }

  spec {
    type = "NodePort"

    selector = {
      app = "${var.environment}-${var.project_name}-converter-api"
    }

    port {
      name        = "${var.environment}-${var.project_name}-api-port"
      protocol    = "TCP"
      port        = 80
      target_port = var.converter_port
      node_port   = 31000
    }
  }
}

# Criação do deployment
resource "kubernetes_deployment" "converter_deployment" {
  metadata {
    name      = "${var.environment}-${var.project_name}-converter-deployment"
    namespace = kubernetes_namespace.converter.metadata[0].name
    labels = {
      name = "${var.environment}-${var.project_name}-converter-deployment"
    }
  }

  spec {
    replicas = 2

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_unavailable = "50%"
      }
    }

    selector {
      match_labels = {
        app = "${var.environment}-${var.project_name}-converter-api"
      }
    }

    template {
      metadata {
        name      = "${var.environment}-${var.project_name}-converter-api"
        namespace = kubernetes_namespace.converter.metadata[0].name
        labels = {
          app = "${var.environment}-${var.project_name}-converter-api"
        }
      }

      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/arch"
                  operator = "In"
                  values   = ["amd64", "arm64"]
                }
              }
            }
          }
        }

        container {
          name              = "${var.environment}-${var.project_name}-converter-api-container"
          image             = "lucasaccurcio/hackaton-converter:latest"
          image_pull_policy = "Always"

          port {
            container_port = var.converter_port
          }

          env_from {
            config_map_ref {
              name = "${var.environment}-${var.project_name}-converter-config-map"
            }
          }

          liveness_probe {
            http_get {
              path = "/converter/health"
              port = var.converter_port
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/converter/health"
              port = var.converter_port
            }
            initial_delay_seconds = 10
            period_seconds        = 10
            failure_threshold     = 5
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }

            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }
      }
    }
  }
}
