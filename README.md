# go-micro — Minimal Go microservices example
A minimal Go microservices example.

## Prerequisites (tools and versions)

- Go 1.16 or later
- Docker

## Running it locally

1. Clone the repository:
```bash
git clone https://github.com/yourusername/go-micro.git
```

2. Navigate to the project directory:
```bash
cd go-micro/project
```

3. On a terminal window, run:
```bash
make up_build
```

4. On another terminal window, run:
```bash
make start
```

5. Populate Postgres DB using users.sql file
```bash
docker cp users.sql project-postgres-1:/users.sql
docker exec -it project-postgres-1 sh
psql -U postgres -d users -f users.sql
rm users.sql
```

The frontend will start on `localhost:80` by default.

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
docker stack deploy -c swarm.yml go-micro
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