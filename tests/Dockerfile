# -*- coding: utf-8 -*-

FROM python:3.9.12-buster

# Set time zone
RUN ln -f -s /usr/share/zoneinfo/Europe/Madrid /etc/localtime

COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

ENV PATH="/root/.local/bin:${PATH}"
WORKDIR /tests
