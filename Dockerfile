FROM ubuntu:18.04

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /docs

COPY Pipfile /docs/

# Set working directory
WORKDIR /docs

RUN apt-get update -qq && apt-get -y install software-properties-common \
  && apt-get -y install python3-pip git bash openssh-client rsync gcc cpp python3-dev \
  ## pour plugins pdf-export (ne fonctionne pas actuellement)
  # build-essential python3-setuptools python3-wheel python3-cffi libcairo2 \
  # libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info \
  && apt-get -y install python3.8 python3.8-dev \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1 \
  && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2 \
  && update-alternatives  --set python /usr/bin/python3.8 \
  && python --version && python -m pip install --no-cache-dir pipenv \
  && pipenv lock --pre && pipenv sync --pre && pipenv graph \
  && apt-get -y remove gcc cpp python3-dev \
  # build-essential python3-setuptools python3-wheel python3-cffi libcairo2 \
  # libpango-1.0-0 libpangocairo-1.0-0 libgdk-pixbuf2.0-0 libffi-dev shared-mime-info \
  && apt-get -y autoremove && apt-get -y autoclean && rm -rf /var/lib/apt/lists/* 

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT [""]
CMD ["pipenv", "run", "mkdocs", "serve", "--dev-addr=0.0.0.0:8000"]
