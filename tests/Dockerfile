FROM python:3.9-slim
LABEL maintainer="pablo.doramas@gmail.com"
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && apt-get purge -y --auto-remove

RUN mkdir /tests
COPY requirements.txt /tests/requirements.txt
RUN pip3 install -r tests/requirements.txt --user --no-warn-script-location

ENV PATH="/root/.local/bin:${PATH}"

COPY . /tests
WORKDIR /tests
