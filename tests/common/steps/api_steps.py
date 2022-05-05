# -*- coding: utf-8 -*-

import json
import requests
from jsonschema import validate
from behave import step
from behave.model import Table
from common.utils.user_utils import log_in
from common.utils.context_utils import get_translated_value


@step('the app is up and running')
def assert_app_up(context):
    response = requests.get(context.app_server)
    assert response.status_code == 200, f'ERROR: The app is throwing status code "{response.status_code}"'


@step('I get a new valid token of the admin "{email}" using password "{password}"')
@step('the admin "{email}" gets a new valid token using password "{password}"')
@step('the user "{email}" gets a new valid token using password "{password}"')
@step('the new user can get a new valid token using password "{password}"')
def get_login_token(context, password, email=None):
    if email is None:
        email = context.new_user["email"]
    context.login_token = log_in(context.app_server, email, password).json()['jwt']


@step('the new user can not log in using password "{password}"')
def user_fails_log_in(context, password):
    response = log_in(context.app_server, context.new_user["email"], password)
    assert 'jwt' not in response.json(), \
        'The login action has generated a token'


@step('I get a valid user uid to query over')
@step('I get a valid user uid to request over')
def get_valid_uuid(context):
    context.table = Table(['header_name', 'header_value'])
    context.table.add_row(['Content-Type', 'application/json'])
    context.table.add_row(['Authorization', f'Bearer {context.login_token}'])
    run_request(context, "GET", "/users")
    context.valid_user_uid = context.api_response.json()["users"][0]["uid"]


@step('I launch a "{method}" request against "{endpoint}" endpoint using these headers')
def run_request(context, method, endpoint, body={}):
    headers = {row['header_name']: get_translated_value(context, row['header_value']) for row in context.table}
    context.api_response = requests.request(method, f'{context.app_server}{get_translated_value(context, endpoint)}', headers=headers, data=body)


@step('I launch a "{method}" request against "{endpoint}" endpoint using this json body and these headers')
def run_request_with_body(context, method, endpoint):
    body = get_translated_value(context, context.text)
    run_request(context, method, endpoint, body)


@step('the response should come with the header "{header_name}" set to "{header_value}"')
def assert_response_header(context, header_name, header_value):
    assert context.api_response.headers[header_name] == header_value, \
        f'The header "{header_name}" in the response is "{context.api_response.headers[header_name]}"'


@step('the response status code is "{status_code:d}"')
def assert_response_status_code(context, status_code):
    assert context.api_response.status_code == status_code, \
        f'ERROR: The status code is "{context.api_response.status_code}"'


@step('the body response matches "{file_path}" json schema')
def match_response_with_json_schema(context, file_path):
    with open(file_path, 'r') as schema_file:
        schema = json.load(schema_file)
    validate(context.api_response.json(), schema)


@step('a new user is created to test over')
def create_new_user(context):
    context.execute_steps('''
        Given I launch a "POST" request against "/users" endpoint using this json body and these headers
          """
          {
            "email": "[RANDOM]@example.com",
            "emailConfirmation": "[RANDOM]@example.com",
            "password": "secretPassword1234",
            "passwordConfirmation": "secretPassword1234",
            "role": "user"
          }
          """
          | header_name   | header_value                 |
          | Content-Type  | application/json             |
          | Authorization | Bearer [CONTEXT:login_token] |
        Then  the response status code is "200"
    ''')
    context.valid_user_uid = context.api_response.json()["user"]["uid"]


@step('a new charger is created to test over')
def create_new_charger(context):
    context.execute_steps('''
        Given I launch a "POST" request against "/chargers" endpoint using this json body and these headers
          """
          {
            "serialNumber": "[RANDOM_INT]",
            "model": "Commander"
          }
          """
          | header_name   | header_value                 |
          | Content-Type  | application/json             |
          | Authorization | Bearer [CONTEXT:login_token] |
        And   the response status code is "200"
    ''')
    context.valid_charger_uid = context.api_response.json()["charger"]["uid"]


@step('the just created charger is assigned to the just created user')
def assign_charger_to_user(context):
    context.execute_steps('''
        When  I launch a "POST" request against "/chargers/[CONTEXT:valid_charger_uid]/users/[CONTEXT:valid_user_uid]" endpoint using these headers
          | header_name   | header_value                 |
          | Content-Type  | application/json             |
          | Authorization | Bearer [CONTEXT:login_token] |
        And   the response status code is "200"
    ''')
