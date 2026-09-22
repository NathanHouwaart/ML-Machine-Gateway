# ML Machine Gateway

The MaintenanceLab Machine Gateway is the one server-side entry point for
machine-related web applications and future authenticated machine services.
It is a Docker Compose deployment, not a replacement for acquisition-machine
software or host-managed NFS storage.

## Boundaries

- The Linux host owns NFS exports and persistent data in `/srv/testbenchdaq`.
- This repository owns Docker deployment, the public Nginx gateway, and route
  configuration.
- Application repositories own their source code and publish versioned images.
- Acquisition machines retain direct control of their attached hardware.

## Quick start

```bash
cp .env.example .env
mkdir -p secrets
docker run --rm --entrypoint htpasswd httpd:2.4-alpine \
  -Bbn viewer 'choose-a-strong-password' > secrets/machine-data.htpasswd
docker compose -f compose.yml up -d
```

This starts the gateway and its `/health` endpoint. After application images
are published, copy `compose.apps.example.yml` to `compose.apps.yml`, select
release tags in `.env`, and start the combined stack. The data portal is then
available at `/data/`, for example
`http://192.168.0.189/data/wentelteef/`.

Read [deployment](docs/deployment.md), [adding a machine](docs/adding-a-machine.md),
and [adding a web service](docs/adding-a-web-service.md) before production use.

## Local workstation test

The repository can safely be tested without the server or its NFS storage.
The local stack uses only `127.0.0.1:8098`, a disposable Profile Creator Docker
volume, and the read-only `C:\ML-Machine-Gateway-TestData` host folder. It
does not mount server or acquisition data, so it cannot alter it.

```powershell
Copy-Item .env.local.example .env.local
Copy-Item compose.local.example.yml compose.local.yml
New-Item -ItemType Directory -Force secrets
docker run --rm --entrypoint htpasswd httpd:2.4-alpine `
  -Bbn viewer 'local-test-password' | Set-Content -NoNewline secrets/machine-data.htpasswd
docker compose --env-file .env.local -f compose.yml -f compose.local.yml up -d
```

Open `http://127.0.0.1:8098/health`, `http://127.0.0.1:8098/knarskast/`, or
`http://127.0.0.1:8098/data/`. The data route prompts for
the local credentials above. Stop only this local stack with
`docker compose --env-file .env.local -f compose.yml -f compose.local.yml down`.
Do not add `-v` unless you deliberately want to erase the local test profiles.
