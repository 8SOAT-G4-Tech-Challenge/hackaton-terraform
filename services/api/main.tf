# Criação da namespace
resource "kubernetes_namespace" "main" {
  metadata {
    name = "${var.environment}-${var.project_name}-main"
  }
}

# Criação do config map
resource "kubernetes_config_map" "main_config_map" {
  metadata {
    name      = "${var.environment}-${var.project_name}-main-config-map"
    namespace = kubernetes_namespace.main.metadata[0].name
    labels = {
      name = "${var.environment}-${var.project_name}-main-config-map"
    }
  }

  data = {
    API_PORT          = "3333"
    DATABASE_URL      = data.aws_db_instance.main_pg_url.endpoint
    CONVERTER_API_URL = var.converter_api_url
  }
}

# Criação do service
resource "kubernetes_service" "conerter_service" {
  metadata {
    name      = "${var.environment}-${var.project_name}-main-service"
    namespace = kubernetes_namespace.main.metadata[0].name
    labels = {
      name = "${var.environment}-${var.project_name}-main-service"
    }
  }

  spec {
    type = "NodePort"

    selector = {
      app = "${var.environment}-${var.project_name}-main-api"
    }

    port {
      name        = "${var.environment}-${var.project_name}-api-port"
      protocol    = "TCP"
      port        = 80
      target_port = 3333
      node_port   = 31333
    }
  }
}

# Criação do deployment
resource "kubernetes_deployment" "main_deployment" {
  metadata {
    name      = "${var.environment}-${var.project_name}-main-deployment"
    namespace = kubernetes_namespace.main.metadata[0].name
    labels = {
      name = "${var.environment}-${var.project_name}-main-deployment"
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
        app = "${var.environment}-${var.project_name}-main-api"
      }
    }

    template {
      metadata {
        name      = "${var.environment}-${var.project_name}-main-api"
        namespace = kubernetes_namespace.main.metadata[0].name
        labels = {
          app = "${var.environment}-${var.project_name}-main-api"
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
          name = "${var.environment}-${var.project_name}-main-api-container"
          # TODO: Corrigir
          # image             = "lucasaccurcio/hackaton-main:latest"
          image             = "lucasaccurcio/tech-challenge-order-api:latest"
          image_pull_policy = "Always"

          port {
            container_port = 3333
          }

          env_from {
            config_map_ref {
              name = "${var.environment}-${var.project_name}-main-config-map"
            }
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = 3333
            }
            initial_delay_seconds = 60
            period_seconds        = 10
            failure_threshold     = 3
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = 3333
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
