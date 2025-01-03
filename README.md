```markdown
# K3s Certbot with Loopia DNS Challenge

Automate SSL certificate management in K3s using Certbot with DNS-01 challenge via Loopia API.

## Prerequisites

- K3s cluster
- Loopia domain and API credentials
- Valid email for Let's Encrypt notifications

## Quick Start

1. Clone repository:
```bash
git clone https://github.com/snis/k3s-certbot.git
cd k3s-certbot
```

2. Generate configurations:
```bash
./generate-k8s-config.sh
```

3. Apply to cluster:
```bash
kubectl apply -k k8s/cert-manager/base
```

## Security

- Generated files contain sensitive data
- Never commit secrets.yaml or generated configurations
- Store credentials securely

## Project Structure

```
k3s-certbot/
├── k8s/
│   └── cert-manager/
│       └── base/           # Kubernetes configurations
├── generate-k8s-config.sh  # Configuration generator
└── README.md
```
## License

Apache License 2.0 - see [LICENSE](LICENSE) for details
