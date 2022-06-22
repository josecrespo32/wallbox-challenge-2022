import json

import requests
from pytest_bdd import scenario, given, when, then
from behave import *
import re
from behave import given, when, then

import logging

logging.basicConfig(filename='wallbox.log', encoding='utf-8', level=logging.DEBUG)

"""
    Given a "GET" HTTP action against the url "http://localhost:3000" and Uri "/"
    When I send the request with headers
          | header_name | header_value     |
          | accept      | application/json |
    Then I should receive a HTTP response "200"
    And body response should be '{"message":"Wallbox Challenge API REST is up and running!"}'
"""


@step('a "{mode}" HTTP action against the url "{urlbase}" and Uri "{uri}"')
def http_action(context, mode, urlbase, uri, ):
    """
    Store info to send a HTTP Request in context
    :param context:
    :param mode: GET, POST, PUT, DELETE
    :param urlbase:
    :param uri:
    :return:
    """

    context.url = str(urlbase + uri)
    context.mode = mode


@step("I send the request with headers without body")
@step("I send the request with headers")
def send_request_with_headers_and_no_body(context):
    """
    Store context headers and send the request to stored endpoint in context
    :param context:
    :param headers:
    :return:
    """

    context.headers = {}
    for row in context.table:
        context.headers[row['header_name']] = row['header_value']

    if context.headers["Authorization"] == "{context.token}":
        context.headers["Authorization"] = context.token

    # send request
    context.response = requests.request(method=context.mode,
                                        headers=context.headers,
                                        url=context.url)

    logging.info('Sent: %s', context.mode)
    logging.info('Sent: %s', context.url)
    logging.info('Sent: %s', context.headers)
    logging.info('Response: %s', context.response)
    logging.info('Response: %s', context.response.text)


@step("I send the request without headers")
def send_request_without_headers(context):
    """
    Store context headers and send the request to stored endpoint in context
    :param context:
    :param headers:
    :return:
    """

    # send request
    context.response = requests.request(method=context.mode, url=context.url)

    logging.info('Sent: %s', context.mode)
    logging.info('Sent: %s', context.url)
    logging.info('Response: %s', context.response)
    logging.info('Response: %s', context.response.text)


@step("I send the request with headers with body")
def send_request_with_headers_with_body(context):
    """
    Store context headers and send the request to stored endpoint in context
    :param context:
    :param headers:
    :return:
    """
    auth = False
    context.headers = {}
    for row in context.table:
        context.headers[row['header_name']] = row['header_value']
        if row['header_name'] == "Authorization":
            auth = True

    if auth:
        if context.headers["Authorization"] == "{context.token}":
            context.headers["Authorization"] = context.token
    else:
        print("NO AUTH DETECTED")

    # send request
    context.response = requests.request(method=context.mode,
                                        headers=context.headers,
                                        url=context.url,
                                        data=context.body)

    logging.info('Sent: %s', context.mode)
    logging.info('Sent: %s', context.url)
    logging.info('Sent: %s', context.headers)
    logging.info('Sent: %s', context.body)
    logging.info('Response: %s', context.response)
    logging.info('Response: %s', context.response.text)


@step('I should receive a HTTP response "{status_code}"')
def check_status_code(context, status_code):
    """
    Assert status code received when request is done is the desired one
    :param context: behave test context
    :param status_code: desired status code
    """

    assert context.response.status_code == int(status_code), \
        f'Expected {status_code} but Received status code {context.response.status_code}'


@step('body response should contain "{text_response}"')
def check_response_json_text(context, text_response):
    """
    check body response as expected
    :param context:
    :param text_response:
    :return:
    """
    assert context.response.text == str(text_response), \
        f'Expected {text_response} but Received {context.response.text}'


@step('body response should contain')
def check_response_json(context):
    """
    check body response with fields checks
    :param context:
    :return:
    """

    # Expected body message
    expected_body = context.table[0][0]

    # Received
    body = context.response.json()
    received_body = json.dumps(body)

    # Check matching
    assert expected_body == received_body, \
        f'Expected body {expected_body} but Received body: {received_body}'


@step('a User with email "{email}" and password "{password}"')
def store_user_data(context, email, password):
    context.user_email = email
    context.user_password = password
    context.user_type = "user"
    body = {
        "email": email,
        "password": password
    }
    context.body = json.dumps(body)


@step('a Admin with email "{email}" and password "{password}"')
def store_user_data(context, email, password):
    context.admin_email = email
    context.admin_password = password
    context.user_type = "admin"


@step(u'the response should include "uid, email and jwt"')
def check_response_uid_email_jwt(context):
    """
    Check response and store Token in context
    :param context:
    :return:
    """

    assert context.response.json()["uid"] != '', 'Missing uid in the response'
    assert context.response.json()["email"] != '', 'Missing uid in the response'
    assert context.response.json()["jwt"] != '', 'Missing uid in the response'

    context.email = context.response.json()["email"]
    context.uid = context.response.json()["uid"]
    context.token = str("Bearer " + context.response.json()["jwt"])


@step(u'the response should include fields "{expected_fields}"')
def check_response_field_list(context, expected_fields):
    """
    Check response and store Token in context
    :param expected_fields:
    :param context:
    :return:
    """
    print(context.response.json())
    expected_fields_list = expected_fields.split(' ')
    for field in expected_fields_list:
        assert context.response.json()[field] != '', f'Missing {field} in the response'
        print(f'Field {field} and Value {context.response.json()[field]}')


################


@step('a user with email {email} and password {password} requests a valid token')
def token_retrieval_admin(context, email, password):
    """
    Exectute steps for Admin token retrieval
    :param context:
    :param email:
    :param password:
    :return:
    """

    context.execute_steps(f"""
    Given a User with email "{email}" and password "{password}"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "200"
    And the response should include "uid, email and jwt"
    """)
    print(context.response.text)


@step("I request data from all users")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.execute_steps("""
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users"
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And I should receive a list of the users
    """)


@then("I should receive a list of the users")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    print(context.response.text)
    context.users = context.response.json()["users"]


@then("I should receive a list of the chargers")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    print(context.response.text)
    context.chargers = context.response.json()["chargers"]


@step("the list of users should be 2 at least")
def users_more_than_2(context):
    """
    :type context: behave.runner.Context
    """
    assert len(context.users) >= 2, "Users retrieved are less than 2"


@step('a "{mode}" HTTP action against the url "{urlbase}" and Uri "{uri}" and UID')
def http_action(context, mode, urlbase, uri):
    """
    Store info to send a HTTP Request in context
    :param context:
    :param mode: GET, POST, PUT, DELETE
    :param urlbase:
    :param uri:
    :return:
    """

    context.url = str(urlbase + uri + "/" + context.selected_uid)
    context.mode = mode


@step('a "{mode}" HTTP action against the url "{urlbase}" and Uri "{uri}" and charger UID')
def http_action(context, mode, urlbase, uri):
    """
    Store info to send a HTTP Request in context
    :param context:
    :param mode: GET, POST, PUT, DELETE
    :param urlbase:
    :param uri:
    :return:
    """

    context.url = str(urlbase + uri + "/" + context.charger_uid)
    context.mode = mode

@step('a "{mode}" HTTP action against the url "{urlbase}" and Uri "{uri}" and charger UID and user UID')
def http_action(context, mode, urlbase, uri):
    """
    Store info to send a HTTP Request in context
    :param context:
    :param mode: GET, POST, PUT, DELETE
    :param urlbase:
    :param uri:
    :return:
    """

    context.url = str(urlbase + uri + "/" + context.charger_uid + "/users/" + context.selected_uid)
    context.mode = mode


@step("I select UID from email {email_selected}")
def select_uid_from_email(context, email_selected):
    """
    :param context:
    :param email_selected:
    :return:
    """
    context.selected_uid = 0
    for user in context.users:
        if user["email"] == email_selected:
            context.selected_uid = user["uid"]
            print(user["uid"])
    if context.selected_uid == 0:
        assert 0 == 1, "Expected user UID not found"


@step("I select UID from chargers {charger_selected}")
def select_uid_from_serial(context, charger_selected):
    """
    :param context: 
    :param charger_selected: 
    :return:
    """
    
    context.selected_uid = 0
    for charger in context.chargers:
        if charger["serialNumber"] == charger_selected:
            context.selected_uid = charger["uid"]
            print(charger["uid"])
    if context.selected_uid == 0:
        assert 0 == 1, "Expected charger UID not found"


@step("User only retrieve his own data")
def setup_uid(context):
    """
    :param email_selected:
    """
    assert len(context.users) == 1
    for user in context.users:
        assert user["email"] == context.user_email
        # context.selected_uid = user["uid"]


@step("prepare body with data")
def prepare_body_params(context):
    """
    :type context: behave.runner.Context
    """
    body = {}
    for row in context.table:
        body[row['body_param_name']] = row['body_param_value']

    context.body = json.dumps(body)


@step('the response body field {field} should be {check_text}')
def check_error_message(context, field, check_text):
    """
    :param field:
    :param check_text:
    :type context: behave.runner.Context
    """
    # print(context.response.json())

    assert context.response.json()[field] == check_text, \
        f'Text does not match! {context.response.json()[field]} vs {check_text}'


@step("I create a new user type {role} with email {email} and password {password}")
def create_user_steps(context, role, email, password):
    """
    :param context:
    :param role:
    :param email:
    :param password:
    :return:
    """
    context.execute_steps(f"""
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/users/"
    And prepare body with data
      | body_param_name      | body_param_value       |
      | email                | {email}  |
      | emailConfirmation    | {email}  |
      | password             | {password}             |
      | passwordConfirmation | {password}             |
      | role                 | {role}                  |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response should include fields "message user"
    And I request data from all users
    """)


@step("I create a new Charger type {model} and ID {idc}")
def step_impl(context, model, idc):
    """
    :type context: behave.runner.Context
    :type model: str
    :type idc: str
    """
    context.execute_steps(f"""
        When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers/"
    And prepare body with data
      | body_param_name | body_param_value |
      | serialNumber    | {idc}             |
      | model           | {model}          |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response should include fields "message charger"
    """)


@step("I store the charger UID from response")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    context.charger = context.response.json()["charger"]
    context.charger_uid = context.charger["uid"]


@step("the charger {id} should include the user {email} as linked")
def step_impl(context, id, email):
    """
    :type context: behave.runner.Context
    :type id: str
    :type email: str
    """
    found = False

    for charger in context.response.json()["chargers"]:
        print(charger["serialNumber"])
        if charger["serialNumber"] == int(id):
            print(charger["users"])
            for user in charger["users"]:
                if user["email"] == email:
                    found = True
                    break

    assert found, f"User not found"


@step("the charger {id} should NOT include the user {email} as linked")
def step_impl(context, id, email):
    """
    :type context: behave.runner.Context
    :type id: str
    :type email: str
    """

    found = False

    for charger in context.response.json()["chargers"]:
        print(charger)
        #print(charger["serialNumber"])


        if charger["serialNumber"] == int(id):
            print(charger["users"])
            for user in charger["users"]:
                if user["email"] == email:
                    found = True
                    break

    assert found == False, f"the User was found"

