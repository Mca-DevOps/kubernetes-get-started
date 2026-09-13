# postgres-example

Deploy PostgreSQL and pgAdmin4 inside a Kubernetes cluster.

## Overview

This project deploys two workloads in a k8s cluster:

- **PostgreSQL** (`postgres:15-alpine`) in a Deployment, exposed internally via a ClusterIP service on port `5432`.
- **pgAdmin4** (`dpage/pgadmin4:latest`) in a Deployment, exposed via a ClusterIP service on port `80` and reachable externally through an Ingress for host `k8s-cluster`.

Credentials for both pods are stored in Kubernetes `Secret` resources.

## Directory layout

```
postgres-example/
├── pgadmin/
│   ├── pgadmin-deployment.yaml
│   ├── pgadmin-ingress.yaml
│   ├── pgadmin-secrets.yaml
│   └── pgadmin-service.yaml
└── postgres/
    ├── postgres-deployment.yaml
    ├── postgres-secrets.yaml
    └── postgres-service.yaml
```

## Components

### postgres/

- `postgres-secrets.yaml`: Secret storing the PostgreSQL root credentials (base64-encoded).
- `postgres-deployment.yaml`: Deployment (1 replica) running `postgres:15-alpine`, reading `POSTGRES_USER` and `POSTGRES_PASSWORD` from the Secret.
- `postgres-service.yaml`: ClusterIP service exposing the database on port `5432`.

### pgadmin/

- `pgadmin-secrets.yaml`: Secret storing pgAdmin login credentials (base64-encoded).
- `pgadmin-deployment.yaml`: Deployment (1 replica) running `dpage/pgadmin4:latest`, reading `PGADMIN_DEFAULT_EMAIL` and `PGADMIN_DEFAULT_PASSWORD` from the Secret.
- `pgadmin-service.yaml`: ClusterIP service exposing the web UI on port `80`.
- `pgadmin-ingress.yaml`: Ingress routing host `k8s-cluster` to the pgAdmin service.

## Usage

Apply the manifests namespace-wise:

```bash
# PostgreSQL
$ kubectl apply -f postgres/

# pgAdmin
$ kubectl apply -f pgadmin/
```

Or apply everything at once:

```bash
$ kubectl apply -f postgres/ -f pgadmin/
```

## Access

- **PostgreSQL**: reachable inside the cluster at `postgres-service:5432`.
- **pgAdmin**: reachable at `http://{minikube ip}/` once the Ingress is up.

### Default credentials

| Component  | Username        | Password     |
|------------|-----------------|--------------|
| PostgreSQL | `admin`         | `password123`|
| pgAdmin    | `admin@k8s.com` | `pgpass123`  |

> Credentials are stored base64-encoded in the Secret manifests. Re-encode your own values before applying:
> ```bash
> $ echo -n "your-password" | base64
> ```

## Cleanup

```bash
$ kubectl delete -f pgadmin/
$ kubectl delete -f postgres/
```