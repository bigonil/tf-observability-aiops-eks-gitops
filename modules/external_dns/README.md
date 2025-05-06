
---

### 📁 `modules/external_dns/README.md`

```markdown
# ExternalDNS Module

Deploys the `external-dns` Helm chart and configures it to manage Route53 DNS records automatically based on Kubernetes Ingress annotations.

## Inputs

| Name             | Type        | Description                             | Default                |
|------------------|-------------|-----------------------------------------|------------------------|
| `domain_filters` | list(string)| List of domains to restrict management  | `["lb-aws-labs.link"]` |

## Requirements

- EKS IAM Role/IRSA properly configured to allow Route53 access
- Hosted zone(s) must exist in AWS Route53

## Example Usage

```hcl
module "external_dns" {
  source         = "../../modules/external_dns"
  domain_filters = ["lb-aws-labs.link"]
}
