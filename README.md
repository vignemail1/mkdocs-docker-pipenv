# mkdocs-material Docker image for Gitlab-CI

- Liveserve (on port 8000) : `docker --rm -it -p 8000:8000 -v $PWD:/docs vignemail1/mkdocs-docker-pipenv:latest`
- build : `docker --rm -it -p 8000:8000 -v $PWD:/docs vignemail1/mkdocs-docker-pipenv:latest pipenv run mkdocs build -c`
- build to another directory (`public`) : `docker --rm -it -p 8000:8000 -v $PWD:/docs vignemail1/mkdocs-docker-pipenv:latest pipenv run mkdocs build -c -d public`

`.gitlab-ci.yml` for mkdocs usage:

```yaml
build-site:
  stage: build
  image: vignemail1/mkdocs-docker-pipenv:latest
  script:
    - pipenv run mkdocs build -c -d public
  artifacts:
    expire_in: 1 week
    paths:
      - public
```
