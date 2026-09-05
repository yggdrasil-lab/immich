# Immich — Self-Hosted Photo & Video Backup

Immich for Yggdrasil, deployed via Docker Swarm on the Muspelheim worker node. Backs up phone photos and videos with deduplication, search, and machine-learning tagging.

## Services

| Service | Role |
|---|---|
| immich-server | API + web UI (port 2283) |
| immich-machine-learning | Facial recognition + smart search (internal) |
| redis | Job queue (Valkey 9, internal) |
| database | PostgreSQL with vector extensions (internal) |

## Deploy

CI/CD runs via GitHub Actions on the gaia self-hosted runner. Push to main triggers deploy automatically. Services are pinned to `muspelheim` via placement constraints.

## Secrets

| Secret | Type | Purpose |
|---|---|---|
| IMMICH_DB_PASSWORD | GitHub secret | Postgres password (injected as a Docker secret at deploy) |

Generate the value with `openssl rand -hex 32`. `DOMAIN_NAME` is reused from the existing repository variable.

## Setup

First-time host setup (run on muspelheim):

```
./setup_host_muspelheim.sh
```

This creates:
- `/mnt/storage/immich/library` — photo/video library (mergerfs pool)
- `/opt/immich/postgres` — database data (local disk)
- `/opt/immich/model-cache` — ML model cache

After the first deploy, open the web UI at `https://photos.${DOMAIN_NAME}` and complete the setup wizard to create the admin account.

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| 2283 | TCP | Immich API + web UI (via Traefik `photos.${DOMAIN_NAME}`) |
| 3003 | TCP | ML endpoint (internal only) |
| 5432 | TCP | PostgreSQL (internal only) |

## Documentation

See the vault: `Areas/90-Infrastructure/Immich/Immich Stack.md`
