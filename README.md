# 📊 Observability & AIOps su EKS – GitOps-ready

Questo repository fornisce un'infrastruttura completa e scalabile per l'**osservabilità e automazione intelligente (AIOps)** su Kubernetes, specificamente ottimizzata per **Amazon EKS**. Include:

- ✅ **Opni** per anomaly detection, RCA e alert enrichment
- ✅ **PredictKube + KEDA** per scaling predittivo automatico
- ✅ **Grafana + Prometheus + Loki** per metriche, log e dashboard
- ✅ **TicketBot** integrato con **Pat HDA** per automazione ticketing
- ✅ **NGINX Ingress** e **AWS Secrets Manager** per sicurezza e accessibilità
- ✅ Supporto completo **GitOps con ArgoCD**, CI/CD con GitHub Actions, GitLab CI e Jenkins

---

## 🚀 Deployment rapido su EKS

1. Provisiona un cluster con `eksctl`:
```bash
eksctl create cluster --name observability-cluster --region eu-west-1 --nodes 3
```

2. Installa ArgoCD:
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

3. Applica un `Application` YAML da `applications/`.

4. ArgoCD sincronizzerà automaticamente i chart Helm con i valori da `environments/dev` o `prod`.

---

## 🔐 Segreti sicuri con AWS Secrets Manager

Usa **External Secrets Operator** per sincronizzare segreti da AWS in Kubernetes.
Esempio incluso in `secrets/grafana-admin-secret.yaml`.

---

## 🌐 Accesso tramite Ingress

Usa NGINX Ingress Controller per esporre:
- Grafana: `https://grafana.yourdomain.com`
- TicketBot: `https://ticketbot.yourdomain.com`

---

## 🛠 CI/CD pipeline supportate

| Sistema        | File                         | Descrizione                         |
|----------------|------------------------------|-------------------------------------|
| GitHub Actions | `.github/workflows/gitops-deploy.yaml` | Validazione e trigger ArgoCD |
| GitLab CI      | `.gitlab-ci.yml`             | Lint Helm, valida YAML e sync      |
| Jenkins        | `Jenkinsfile`                | Pipeline compatibile con Jenkins    |

---

## 🤝 Contribuisci

Le PR sono benvenute! Se hai una nuova feature (es. alerting vocale, dashboard predefinite, autoscaler avanzati) apri una issue o una PR.

---

## 🧾 Licenza

Distribuito sotto licenza MIT.

---

## ✨ Autori

Questo progetto è stato generato con ❤️ da [Luca] e ottimizzato per ambienti enterprise.
