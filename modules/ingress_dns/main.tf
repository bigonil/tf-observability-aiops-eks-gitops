variable "host" {}
variable "service_name" {}
variable "namespace" {}
variable "tls_secret" {}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "${var.service_name}-ingress"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class"                             = "nginx"
      "cert-manager.io/cluster-issuer"                          = "letsencrypt-prod"
      "external-dns.alpha.kubernetes.io/hostname"              = var.host
    }
  }

  spec {
    tls {
      hosts      = [var.host]
      secret_name = var.tls_secret
    }

    rule {
      host = var.host
      http {
        path {
          path     = "/"
          path_type = "Prefix"

          backend {
            service {
              name = var.service_name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}