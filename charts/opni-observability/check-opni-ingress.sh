#!/bin/bash

NAMESPACE="opni-system"
DOMAINS=("aiopsgw.lb-aws-labs.link" "grafana.lb-aws-labs.link")

echo "Checking cert-manager..."
kubectl get clusterissuer letsencrypt-prod && echo "ClusterIssuer found" || echo "ClusterIssuer NOT found"

echo "Checking Certificate resources..."
kubectl get certificates -n $NAMESPACE

for DOMAIN in "${DOMAINS[@]}"; do
  echo -e "\nTesting Ingress for https://$DOMAIN ..."

  echo "DNS Resolution:"
  dig +short $DOMAIN || echo "DNS lookup failed"

  echo "HTTP Status:"
  curl -I --max-time 5 https://$DOMAIN || echo "HTTPS endpoint unreachable"

  echo "TLS Certificate Info:"
  echo | openssl s_client -connect $DOMAIN:443 -servername $DOMAIN 2>/dev/null | openssl x509 -noout -issuer -subject -dates || echo "Failed to fetch TLS cert"
done