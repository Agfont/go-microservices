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

## Deploy locally with Kubernetes (minikube) and Ingress

1. Start PostgreSQL on the host machine:
```bash
docker-compose -f project/postgres.yml up -d
```

2. Start a local Minikube cluster:
```bash
minikube start
```

3. Enable the Ingress addon in Minikube:
```bash
minikube addons enable ingress
```

4. Apply the ingress resources:
```bash
kubectl apply -f project/ingress.yml
```

5. Set hosts front-end.info and broker-service.info as 127.0.0.1
```bash
sudo vi /etc/hosts
```

6. Apply the Kubernetes deployment manifests:

```bash
kubectl apply -f project/k8s
```

7. Start a Minikube tunnel to expose ingress routes:
```bash
minikube tunnel
```

Navigate to: http://front-end.info

8. Remove the deployment files:
```bash
kubectl delete -f project/k8s
kubectl delete -f project/ingress.yml
```

9. Stop the Minikube cluster:
```bash
minikube stop
```

10. Stop PostgreSQL on the host machine:
```bash
docker-compose -f project/postgres.yml down
```