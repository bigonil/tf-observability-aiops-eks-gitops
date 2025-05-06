variable "domain_filters" {
  type    = list(string)
  default = ["lb-aws-labs.link"]
}

provider "helm" {}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = "1.14.2"

  set {
    name  = "provider"
    value = "aws"
  }

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "aws.region"
    value = "us-west-2"
  }

  dynamic "set" {
    for_each = var.domain_filters
    content {
      name  = "domainFilters[${set.key}]"
      value = set.value
    }
  }

  set {
    name  = "txtOwnerId"
    value = "external-dns"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }
}