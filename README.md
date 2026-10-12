# belli

Belli is a gut health app. Users log their **intake** (food, alcohol, sleep, exercise, and more) and their **outtake** (bowel movements). Belli looks for correlations between the two so each user can spot the intakes that cause them problems and see how their lifestyle affects their gut health.

Built with [Cookiecutter Django](https://github.com/cookiecutter/cookiecutter-django/): Django, Postgres, Celery + Redis, and Docker. This repo is a monorepo; a mobile app will live alongside the Django project later.

## Running locally

Requires [Docker](https://www.docker.com/products/docker-desktop/).

```bash
export COMPOSE_FILE=docker-compose.local.yml   # or pass -f docker-compose.local.yml to each command

docker compose build
docker compose up                # migrations run automatically on start
```

| Service | URL |
|---|---|
| App | http://localhost:8000 |
| Mailpit (catches outgoing email) | http://localhost:8025 |
| Flower (Celery monitor; login is `CELERY_FLOWER_USER`/`CELERY_FLOWER_PASSWORD` in `.envs/.local/.django`) | http://localhost:5555 |

Local environment variables live in `.envs/.local/`.

### Common commands

```bash
docker compose run --rm django python manage.py createsuperuser
docker compose run --rm django python manage.py makemigrations
docker compose run --rm django pytest
docker compose run --rm django mypy belli
docker compose down              # stop; add -v to also delete the database
```

New users sign up at `/accounts/signup/`. The verification email shows up in Mailpit.

## Docs

- [Cookiecutter Django settings](https://cookiecutter-django.readthedocs.io/en/latest/1-getting-started/settings.html)
- [Local development with Docker](https://cookiecutter-django.readthedocs.io/en/latest/2-local-development/developing-locally-docker.html)
- [Deployment with Docker](https://cookiecutter-django.readthedocs.io/en/latest/3-deployment/deployment-with-docker.html)
