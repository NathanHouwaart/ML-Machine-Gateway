# Adding a web service or container

Each application is a separate internal Docker service. It joins the `private`
network and gets one explicit Nginx route. It must not publish a host port.

1. Publish the application image from its own repository, preferably with an
   immutable release tag in GitHub Container Registry.
2. Add its service to `compose.apps.yml`:

```yaml
services:
  reports-web:
    image: ghcr.io/nathanhouwaart/ml-reports-web:1.0.0
    restart: unless-stopped
    networks: [private]
```

3. Add `gateway/routes/30-reports.conf`:

```nginx
location = /reports { return 308 /reports/; }
location /reports/ {
    rewrite ^/reports/(.*)$ /$1 break;
    set $reports_upstream reports-web:8080;
    proxy_pass http://$reports_upstream;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

4. If it is a single-page application, build it with relative asset URLs (for
   Vite, `base: "./"`) so `/reports/assets/...` stays beneath the route.
5. Validate and deploy:

```bash
docker compose -f compose.yml -f compose.apps.yml config
docker compose -f compose.yml -f compose.apps.yml up -d
```

Use an API service behind a web service where possible. Add authentication and
authorization at the gateway for sensitive routes. Never publish a container
port directly unless it is intentionally a separate public service.
