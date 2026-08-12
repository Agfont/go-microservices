# go-microservices — Minimal Go microservices example
A minimal Go microservices example.

## Prerequisites (tools and versions)

- Go 1.16 or later
- Docker

## Running it locally

1. Clone the repository:
```bash
git clone https://github.com/Agfont/go-microservices.git
```

2. Navigate to the project directory:
```bash
cd go-microservices/project
```

3. Build service binaries, rebuild Docker images, and start all backend services:
```bash
make up_build
```

4. In a second terminal, start the frontend on port 80:
```bash
cd go-microservices/project
make start
```

The frontend starts on `localhost:80` by default.

5. Stop and remove the Docker Compose services:
```bash
make down
```

6. Stop only the frontend process:
```bash
make stop
```

## Deploy locally with Docker Swarm and Caddy

1. From the repository root, initialize Docker Swarm:
```bash
cd ..
docker swarm init
```

2. Build tagged images for all microservices and push them to Docker Hub:
```bash
docker build -f broker-service/broker-service.dockerfile -t arthurfont/broker-service:1.0.0 ./broker-service
docker push arthurfont/broker-service:1.0.0

docker build -f authentication-service/authentication-service.dockerfile -t arthurfont/authentication-service:1.0.0 ./authentication-service
docker push arthurfont/authentication-service:1.0.0

docker build -f front-end/front-end.dockerfile -t arthurfont/front-end:1.0.0 ./front-end
docker push arthurfont/front-end:1.0.0

docker build -f listener-service/listener-service.dockerfile -t arthurfont/listener-service:1.0.0 ./listener-service
docker push arthurfont/listener-service:1.0.0

docker build -f logger-service/logger-service.dockerfile -t arthurfont/logger-service:1.0.0 ./logger-service
docker push arthurfont/logger-service:1.0.0

docker build -f mailer-service/mailer-service.dockerfile -t arthurfont/mailer-service:1.0.0 ./mailer-service
docker push arthurfont/mailer-service:1.0.0
```

3. Initialize the swarm and deploy the stack:
```bash
docker swarm init
docker stack deploy -c project/swarm.yml --resolve-image=never go-microservices
```

4. Remove the stack and leave the swarm:
```bash
docker stack rm go-microservices
docker swarm leave --force
``` 

5. Add backend host to etc/hosts file as 127.0.0.1:
```bash
sudo vi /etc/hosts
```

The frontend will start on `localhost:80` by default.

## Deploy locally with Kubernetes (minikube) and Gateway API

1. Start PostgreSQL on the host machine (image: `postgres:18`):
```bash
docker-compose -f project/postgres.yml up -d
```

2. Start a local Minikube cluster:
```bash
minikube start
```

3. Install the Gateway API CRDs and a controller that implements them.

   [Gateway API is an add-on](https://kubernetes.io/docs/concepts/services-networking/gateway/):
   its kinds are not part of core Kubernetes, and Minikube ships no Gateway
   controller. This project uses
   [NGINX Gateway Fabric](https://docs.nginx.com/nginx-gateway-fabric/), which
   creates the `nginx` GatewayClass referenced by `project/gateway.yml`:

```bash
# Gateway API CRDs (v1.5.1, pinned to the NGF release below)
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.6.7" | kubectl apply --server-side -f -

# NGINX Gateway Fabric CRDs, then the controller itself
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.6.7/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.6.7/deploy/default/deploy.yaml
```

The CRDs are applied with `--server-side` because some of their schemas exceed
the 256KB limit of the `last-applied-configuration` annotation that client-side
apply writes. If a previous client-side apply already created them, add
`--force-conflicts` to take over field ownership.

Wait for the controller and confirm the GatewayClass is accepted:
```bash
kubectl -n nginx-gateway wait --for=condition=Available deploy/nginx-gateway --timeout=120s
kubectl get gatewayclass
```

4. Apply the Gateway API resources:
```bash
kubectl apply -f project/gateway.yml
```

NGINX Gateway Fabric provisions an NGINX data plane and a `LoadBalancer`
Service for the Gateway, which is why `minikube tunnel` is needed in step 7.

5. Set hosts front-end.info and broker-service.info as 127.0.0.1
```bash
sudo vi /etc/hosts
```

6. Apply the Kubernetes deployment manifests:

```bash
kubectl apply -f project/k8s
```

7. Start a Minikube tunnel to expose Gateway routes:
```bash
minikube tunnel
```

Validate Gateway resources are accepted:
```bash
kubectl get gateway
kubectl get httproute
```

Navigate to: http://front-end.info

8. Open Kubernetes dashboard (optional):
```bash
minikube dashboard
```

9. Remove the deployment files:
```bash
kubectl delete -f project/k8s
kubectl delete -f project/gateway.yml
```

10. Stop the Minikube cluster:
```bash
minikube stop
```

11. Stop PostgreSQL on the host machine:
```bash
docker-compose -f project/postgres.yml down
```