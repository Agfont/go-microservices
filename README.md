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

3. On a terminal window, run:
```bash
make up_build
```

4. On another terminal window, run:
```bash
cd go-microservices/project
make start
```

The frontend will start on `localhost:80` by default.

5. To stop the services, run:
```bash
make down
```

6. To stop frontend:
```bash
make stop
```

## Deploy locally with Docker Swarm and Caddy

1. On a terminal window, run:
```bash
docker swarm init
```

2. Build all tag images for our microsservices and push to Docker Hub
```bash
docker build -f logger-service.dockerfile -t arthurfont/logger-service:1.0.0 .
docker push arthurfont/broker-service:1.0.0
```

3. Deploy:
```bash
docker stack deploy -c swarm.yml go-microservices
```

## Deploy locally with Kubernetes (minikube) and Ingress

1. Run:
```bash
minikube start
```

2. Run:
```bash
minikube addons enable ingress
```

3. Run:
```bash
kubectl apply -f ingress.yml
```

4. Set hosts front-end.info and broker-service.info as 127.0.0.1
```bash
sudo vi /etc/hosts
```

5. Run:
```bash
minikube tunnel
```

Navigate to: http://front-end.info