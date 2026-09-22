# Deployment

Install Docker Engine and the Compose plugin on `192.168.0.189`. NFS remains a
host service because it owns the physical server disks; containers only receive
read-only access to measurement data.

Clone this repository to `/opt/ml-machine-gateway`, create `.env` and
`compose.apps.yml` from their examples, and create `secrets/machine-data.htpasswd`.
The secret directory is ignored by Git.

Only this gateway may bind `192.168.0.189:80`. Before migration, stop the old
Profile Creator gateway or move its routes and services into this stack. Do not
run two containers that both publish port 80.

Start or update the stack:

```bash
cp compose.apps.example.yml compose.apps.yml
docker compose -f compose.yml -f compose.apps.yml pull
docker compose -f compose.yml -f compose.apps.yml up -d
```

Do this only after the referenced application images have been published. Until
then, start the gateway alone with `docker compose -f compose.yml up -d`.

Use immutable image tags in `.env` for production, then back up both
`/srv/testbenchdaq` and the local `secrets/` directory separately.
