
---

### 📁 `modules/ingress_dns/README.md`

```markdown
# Ingress with ExternalDNS Module

Creates a Kubernetes Ingress resource with:
- ExternalDNS auto-DNS support
- TLS via cert-manager
- Routing to internal services

## Inputs

| Name          | Type   | Description                                      | Required |
|---------------|--------|--------------------------------------------------|----------|
| `host`        | string | The hostname for the ingress (DNS name)         | ✅ Yes   |
| `service_name`| string | Backend Kubernetes service to expose            | ✅ Yes   |
| `namespace`   | string | Namespace where service and ingress live        | ✅ Yes   |
| `tls_secret`  | string | Name of the TLS secret to store the certificate | ✅ Yes   |

## Example Usage

```hcl
module "gateway_ingress" {
  source       = "../../modules/ingress_dns"
  host         = "aiopsgw.lb-aws-labs.link"
  service_name = "opni-gateway"
  namespace    = "default"
  tls_secret   = "gateway-tls"
}
