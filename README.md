# belli

Belli is a gut health app. Users log their **intake** (food, alcohol, sleep, exercise, and more) and their **outtake** (bowel movements). Belli looks for correlations between the two so each user can spot the intakes that cause them problems and see how their lifestyle affects their gut health.

Built with [Cookiecutter Django](https://github.com/cookiecutter/cookiecutter-django/): Django, Postgres, Celery + Redis, and Docker. This repo is a monorepo; a mobile app will live alongside the Django project later.

## Running locally

### Prerequisites

```bash
brew install --cask docker-desktop   # or download from docker.com
brew install just                    # optional, wraps the commands below
```

Start Docker Desktop and let it finish booting before running anything. The `docker`
command is only a client; it talks to a daemon running in a Linux VM that Docker Desktop
manages. `Cannot connect to the Docker daemon` means that VM isn't up yet.

### First run

```bash
export COMPOSE_FILE=docker-compose.local.yml   # or pass -f docker-compose.local.yml to each command

cp .envs/.local/.django.example .envs/.local/.django
cp .envs/.local/.postgres.example .envs/.local/.postgres

docker compose build             # 5-10 minutes the first time, seconds after that
docker compose up                # migrations run automatically on start
```

| Service | URL |
|---|---|
| App | http://localhost:8000 |
| Mailpit (catches outgoing email) | http://localhost:8025 |
| Flower (Celery monitor; login is `CELERY_FLOWER_USER`/`CELERY_FLOWER_PASSWORD` in `.envs/.local/.django`) | http://localhost:5555 |

Local environment variables live in `.envs/.local/`. The real files are gitignored; the
committed `.example` files next to them are the templates. Your copies are yours to edit,
and the defaults work as-is.

**This repo is public. Never commit a credential** — no API keys, no third-party tokens,
nothing you would mind publishing. Real values belong in your gitignored
`.envs/.local/*`, in `.envs/.production/`, or in an untracked `.env`.

### Common commands

```bash
docker compose run --rm django python manage.py createsuperuser
docker compose run --rm django python manage.py makemigrations
docker compose run --rm django pytest
docker compose run --rm django mypy belli
docker compose down              # stop; add -v to also delete the database
```

With `just` installed, those are wrapped: `just build`, `just up`, `just down`,
`just logs <service>`, `just manage <cmd>`, `just pytest`, `just prune`. Run `just` to
list them. It also sets `COMPOSE_FILE` for you.

Note `docker compose run --rm` starts a fresh throwaway container, while
`docker compose exec` runs inside the already-running one. Use `exec` to inspect live
state, `run` for one-off tasks.

New users sign up at `/accounts/signup/`. The verification email shows up in Mailpit.

### Linting

`pre-commit` runs ruff, djLint, and django-upgrade. CI enforces it on every push, so
installing the git hook locally just saves a round trip:

```bash
brew install pre-commit   # the hook runs on the host, outside the containers
pre-commit install
```

## Gotchas

- **Changing Postgres credentials.** `POSTGRES_USER` and `POSTGRES_PASSWORD` in
  `.envs/.local/.postgres` are only read when the database volume is first created.
  Editing them later gives authentication failures until the volume is recreated:
  `docker compose down -v && docker compose up`.
- **Creating a superuser without a TTY** (CI, or any non-interactive shell):

  ```bash
  docker compose run --rm -T \
    -e DJANGO_SUPERUSER_EMAIL=you@example.com \
    -e DJANGO_SUPERUSER_PASSWORD=changeme \
    django python manage.py createsuperuser --noinput
  ```

  Accounts are identified by email; the `User` model has no username field.
- **`__pycache__` directories appear in your working tree.** The repo is bind-mounted into
  the containers at `/app`, so bytecode caches are written to your checkout. They are
  gitignored.

## Docs

- [Cookiecutter Django settings](https://cookiecutter-django.readthedocs.io/en/latest/1-getting-started/settings.html)
- [Local development with Docker](https://cookiecutter-django.readthedocs.io/en/latest/2-local-development/developing-locally-docker.html)
- [Deployment with Docker](https://cookiecutter-django.readthedocs.io/en/latest/3-deployment/deployment-with-docker.html)
