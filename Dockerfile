# pull official base image
FROM python:3.7-alpine

# set work directory
WORKDIR /medrec1

# set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2
RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add postgresql-dev \
    && pip install psycopg2 \
    && apk del build-deps

# install dependencies
RUN pip install --upgrade pip
RUN pip install pipenv
COPY ./Pipfile /medrec1/Pipfile
RUN pipenv install --skip-lock --system

# copy entrypoint-prod.sh
COPY ./entrypoint.prod.sh /medrec1/entrypoint.prod.sh

# copy project
COPY . /medrec1/

# run entrypoint.prod.sh
ENTRYPOINT ["/medrec1/entrypoint.prod.sh"]

