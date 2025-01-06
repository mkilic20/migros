# 2048 Game Kubernetes Deployment

This project deploys the popular 2048 game on a local Kubernetes cluster using KIND (Kubernetes IN Docker). The implementation includes a MySQL database for storing high scores, and the application is made accessible via a web browser.

## Credits

The core 2048 game implementation is based on [gabrielecirulli/2048](https://github.com/gabrielecirulli/2048). We've extended the original game by adding:

- Node.js backend for score management
- MySQL database integration
- Nginx as reverse proxy
- Kubernetes deployment configuration using Helm

## Prerequisites

- Docker
- kubectl
- KIND (Kubernetes IN Docker)
- Helm v3
- Git

## Repository Structure

```
.
├── 2048/                   # Game source code and Dockerfile
│   ├── api/               # Node.js backend
│   └── ...               # Original 2048 game files
├── helm/                  # Helm charts
│   └── charts/
│       └── 2048-game/    # Main chart for the game
│           ├── templates/ # K8s manifests
│           ├── values.yaml
│           └── Chart.yaml
└── README.md
```

## Setup Instructions

### 1. Create KIND Cluster

```bash
# Create a new KIND cluster
kind create cluster --name 2048-cluster

# Verify cluster is running
kubectl cluster-info --context kind-2048-cluster
```

### 2. Deploy NGINX Ingress Controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for NGINX Ingress controller to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

### 3. Configure Local DNS

Add the following entry to your `/etc/hosts` file:

```bash
sudo echo "127.0.0.1 2048-game.local" >> /etc/hosts
```

### 4. Deploy the Application

```bash
# Navigate to helm directory
cd helm

# Install the Helm chart
helm install 2048-game ./charts/2048-game

# Wait for all pods to be ready
kubectl get pods -w
```

### 5. Access the Game

Once all pods are running, you can access the game at:

```
http://2048-game.local/
```

## Database Configuration

The application uses MySQL to store high scores. The database is automatically initialized using the configuration in `helm/charts/2048-game/sql/init.sql`.

## Troubleshooting

1. Check pod status:

```bash
kubectl get pods
```

2. View pod logs:

```bash
kubectl logs <pod-name>
```

3. If the ingress is not working:

```bash
kubectl get ingress
kubectl describe ingress 2048-game-ingress
```

## Cleanup

To remove the deployment:

```bash
# Remove the Helm release
helm uninstall 2048-game

# Delete the KIND cluster
kind delete cluster --name 2048-cluster
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the original [2048 game repository](https://github.com/gabrielecirulli/2048) for details.
