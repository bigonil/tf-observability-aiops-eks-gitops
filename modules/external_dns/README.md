
---

# ExternalDNS Module

This module deploys the [`external-dns`](https://github.com/kubernetes-sigs/external-dns) Helm chart and configures it to automatically manage AWS Route53 DNS records based on Kubernetes Ingress annotations.

---

## 🚀 Requirements

- An EKS cluster with IAM Roles for Service Accounts (IRSA) configured to allow access to Route53.
- AWS Route53 hosted zone(s) must already exist for the domain(s) being managed.

---

## 🔧 Inputs

| Name             | Type         | Description                             | Default                  |
|------------------|--------------|-----------------------------------------|--------------------------|
| `domain_filters` | list(string) | List of domains to restrict management  | `["lb-aws-labs.link"]`   |

---

## 📦 Example Usage

```hcl
module "external_dns" {
  source         = "../../modules/external_dns"
  domain_filters = ["lb-aws-labs.link"]
}
