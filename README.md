# mkdocs-material Docker image for Gitlab-CI

- Liveserve (on port 8000) : `docker --rm -it -p 8000:8000 -v $PWD:/docs vignemail1/mkdocs-docker-pipenv:latest`
- build : `docker --rm -it -v $PWD:/docs vignemail1/mkdocs-docker-pipenv:latest pipenv run mkdocs build -c`
- build to another directory (`public`) : `docker --rm -it -v $PWD:/docs vignemail1/mkdocs-docker-pipenv:latest pipenv run mkdocs build -c -d public`

`.gitlab-ci.yml` for mkdocs usage:

```yaml
variables:
  GIT_SUBMODULE_STRATEGY: recursive
  GIT_DEPTH: 1000
  GIT_STRATEGY: none

stages:
  - build
  - deploy

build-site:
  stage: build
  image: vignemail1/mkdocs-docker-pipenv:latest
  script:
    - cp /docs/Pipfile* /tmp/
    - rm -rf /docs
    - git clone $CI_REPOSITORY_URL /docs
    - cp /tmp/Pipfile* /docs
    - cd /docs
    - pipenv sync
    - pipenv run mkdocs build -c -d public
    - mv public $CI_PROJECT_DIR/
    - cd $CI_PROJECT_DIR/

  artifacts:
    expire_in: 1 week
    paths:
      - public

deploy-to-prod:
  image: vignemail1/mkdocs-docker-pipenv:latest
  stage: deploy
  environment:
    url: 'https://xxxxx'
    name: production
  before_script:
    - 'which ssh-agent || ( apt-get update -qqy && apt-get install -qqy openssh-client git )'
    - apt install -qqy rsync
    - eval $(ssh-agent -s)
    - echo "${SSH_PRIVATE_KEY}" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
    - '[[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config'
  script:
    - echo "Deploying site to production environment"
    - echo "Other actions to do like SSH handling and file transfer (rsync over SSH?)"
  only:
    - master
  when: manual

```
