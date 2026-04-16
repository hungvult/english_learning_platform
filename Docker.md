# Docker

All services run from the **project root** with a single `docker-compose.yml`.

## Services

| Service     | Port | Description                         |
| ----------- | ---- | ----------------------------------- |
| `sqlserver` | 1433 | SQL Server 2022 Developer Edition   |
| `backend`   | 8000 | FastAPI — hot-reload                |
| `client`    | 3000 | Next.js — hot-reload                |
| `seeder`    | —    | One-shot seed job (exits when done) |

## How to Run

### First run — build images and start everything

```bash
docker compose up --build
```

### Subsequent runs — no rebuild

```bash
docker compose up
```

### Detached (background) mode

```bash
docker compose up -d
```

### Re-run project (I guess)

```bash
docker compose down -v && docker compose up -d
```

### Re-run seeder only (stack already running)

```bash
docker compose run --rm seeder
```

The seeder is idempotent — safe to run multiple times.

## Manage Containers

| Command                       | Purpose                                                    |
| ----------------------------- | ---------------------------------------------------------- |
| `docker compose ps`           | Status of all services                                     |
| `docker compose logs -f`      | Live logs for all services                                 |
| `docker compose logs backend` | Logs for the backend only                                  |
| `docker compose logs seeder`  | Check seed output / errors                                 |
| `docker compose down`         | Stop and remove containers                                 |
| `docker compose down -v`      | Stop, remove containers **and** delete the database volume |

## Rebuild After Changes

```bash
# Python dependencies changed (requirements.txt)
docker compose build backend seeder

# Client dependencies changed (package.json)
docker compose build client

# Full clean rebuild
docker compose down -v && docker compose up --build
```

## Dockerfile Architecture

`backend` and `seeder` both build from **`server/Dockerfile`** using different
multi-stage targets:

```
server/Dockerfile (build context: project root)
├── builder  — ODBC build deps + Python wheels
├── runtime  — lean image: ODBC runtime + packages + server app
├── dev      ← backend service  (uvicorn --reload)
└── seeder   ← seeder service   (seed.py one-shot)
```

Shared build cache — both services build together without cross-image
dependencies.

## URLs

| URL                         | Description       |
| --------------------------- | ----------------- |
| http://localhost:3000       | Client (Next.js)  |
| http://localhost:8000       | Backend (FastAPI) |
| http://localhost:8000/docs  | Swagger UI        |
| http://localhost:8000/redoc | ReDoc             |

## Default Credentials

| Resource    | Value                 |
| ----------- | --------------------- |
| SA password | `YourStrong!Passw0rd` |
| Database    | `EnglishLearning`     |
| Admin login | `admin@elp.local`     |
| All user pw | `abc123`              |
| SQL port    | `localhost:1433`      |

## Hot Reload

- **Backend** — `./server/app` is bind-mounted. Any `.py` save triggers uvicorn
  reload.
- **Client** — `./client` is bind-mounted. Next.js HMR handles changes
  automatically.

## Troubleshooting

**SQL Server takes too long to start**

Normal on first run or slow machines. The healthcheck allows \~2 minutes
(`start_period: 30s`, `retries: 12 × 10s`). Backend and seeder wait for it
before connecting.

**Seeder fails**

```bash
docker compose logs seeder
```

**Port already in use**

Stop any local services on 1433, 8000, or 3000 before running compose.
