# -*- coding: utf-8 -*-

import json
import requests


def log_in(host, email, password):
    return requests.post(f'{host}/signin',
                         headers={"content-type": "application/json"},
                         data=json.dumps({"email": email, "password": password}))


def get_uid_by_login(host, email, password):
    return log_in(host, email, password).json()['uid']
