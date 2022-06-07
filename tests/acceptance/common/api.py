from behave import *
from common.utils import get_value_from_json_path, get_value_from_context
import requests
import json
import logging

logging.basicConfig(filename='api.log', encoding='utf-8', level=logging.DEBUG)


@fixture
def check_api_health(context):
    """
    Check api health
    :param context: behave test context
    """
    context.execute_steps('''
        Given the request host "http://localhost:3000"
        And the request path "/"
        And the request headers
          | header_name | header_value     |
          | accept      | application/json |
        When I make a "GET" request
        Then status code is "200"
        And the response headers are
          | header_name                 | header_value                    |
          | access-control-allow-origin | *                               |
          | content-length              | 59                              |
          | content-type                | application/json; charset=utf-8 |
          | x-powered-by                | Express                         |
        And json response body is the following
        """
        {
          "message": "Wallbox Challenge API REST is up and running!"
        }
        """
    ''')


@step('the request host "{host}"')
def define_host(context, host):
    """
    Save host value to context to use it in next steps
    :param context: behave test context
    :param host: host you will point your requests to
    """
    context.host = host


@step('the request path "{path}"')
def define_path(context, path):
    """
    Save path value to context to use it in next steps
    :param context: behave test context
    :param path: path that will form the url concatenated with host
    """

    if 'CONTEXT' not in path:
        final_path = path
    else:
        final_path = ''

        for part in path.split('/'):
            if 'CONTEXT' in part:
                final_path += f'{get_value_from_context(context, part)}/'
            else:
                final_path += f'{part}/'

    context.path = final_path
    logging.info('PATH: %s', context.path)


@step('the request headers')
def define_headers(context):
    """
    Save headers to context to use them when you make the actual request
    :param context: behave test context
    """
    context.headers = {}
    for row in context.table:
        context.headers[row['header_name']] = row['header_value']
    logging.info('HEADERS: %s', context.headers)


@step('the request body')
def define_body(context):
    """
    Save body to context to use it when you make the actual request
    :param context: behave test context
    """
    body = json.loads(context.text)
    context.body = json.dumps(body)
    logging.info('BODY: %s', context.body)


@step('I make a "{verb}" request')
def make_request(context, verb):
    """
    Make the actual request to previously defined host + path using headers and body if required in type of request (POST/PUT/PATCH)
    :param context: behave test context
    :param verb: supported verbs (GET/POST/PUT/DELETE/PATCH)
    """
    assert verb in ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'], 'Not  a valid verb to make the request'

    if verb == 'GET':
        context.request = requests.get(context.host + context.path, headers=context.headers)
    elif verb == 'POST':
        context.request = requests.post(context.host + context.path, headers=context.headers, data=context.body)
    elif verb == 'PUT':
        context.request = requests.put(context.host + context.path, headers=context.headers, data=context.body)
    elif verb == 'DELETE':
        context.request = requests.delete(context.host + context.path, headers=context.headers)
    elif verb == 'PATCH':
        context.request = requests.patch(context.host + context.path, headers=context.headers, data=context.body)

    if hasattr(context, 'values'):
        context.values["jwt"] = None


@step('status code is "{status_code}"')
def check_status_code(context, status_code):
    """
    Assert status code received when request is done is the desired one
    :param context: behave test context
    :param status_code: desired status code
    """
    assert context.request.status_code == int(status_code), f'Received status code {context.request.status_code} is not the expected {status_code}'


@step('json response body is the following')
def check_json_response_body(context):
    """
    Assert body received when request is done is the desired one
    :param context: behave test context
    """
    expected_body = json.loads(context.text)
    assert expected_body == context.request.json(), f'Received body: {context.request.json()} is not the expected body: {expected_body}'


@step('the response headers are')
def check_headers(context):
    """
    Assert headers received when request is done are the desired ones
    :param context: behave test context
    """
    for row in context.table:
        assert context.request.headers[row['header_name']]


@step('response body contains "{field}" field')
@step('response body contains "{field}" field with value "{value}"')
def check_json_response_body_contains(context, field, value=None):
    """
    Assert field is present in response body, if value is passed as argument assert field value is the desired one
    :param context: behave test context
    :param field: field that will be checked in response body
    :param value: value that will be checked in response body
    """
    received_body = json.loads(context.request.text)

    logging.info('RECEIVED BODY: %s', received_body)

    if value:
        if 'CONTEXT' in value:
            value = get_value_from_context(context, value)
        assert str(get_value_from_json_path(received_body,
                                            field)) == value, f'Received value: {get_value_from_json_path(received_body, field)} is not the expected: {value}'
    else:
        assert get_value_from_json_path(received_body, field), f'Field: {field} not present in response body'


@step('I save "{field}" field value to context')
def save_field_value_to_context(context, field):
    """
    Save field value to context to use it in another step
    :param context: behave test context
    :param field: name of the field which value will be stored in context
    """
    received_body = json.loads(context.request.text)

    if '.' in field:
        field_to_save = field.replace('.', '_')
    else:
        field_to_save = field

    if hasattr(context, 'values'):
        context.values[field_to_save] = get_value_from_json_path(received_body, field)
    else:
        context.values = {}
        context.values[field_to_save] = get_value_from_json_path(received_body, field)
    logging.info('STORED FIELD: %s %s', context.values[field_to_save], field_to_save)


@step('I get a jwt for email: {email} and password: {password}')
def set_auth_header(context, email, password):
    """
    Store a valid jwt in context
    :param context: behave test context
    :param email: email of the user for which you want to get the jwt
    :param password: password of the user for which you want to get the jwt
    """

    context.execute_steps(f'''
        Given the request host "http://localhost:3000"
        And the request path "/signin"
        And the request headers
        | header_name  | header_value     |
        | accept       | application/json |
        | Content-Type | application/json |
        And the request body
        """
        {{
            "email": "{email}",
            "password": "{password}"
        }}
        """
        When I make a "POST" request
        Then status code is "200"
    ''')

    save_field_value_to_context(context, 'jwt')


@step('I add jwt to headers in order to authenticate')
def add_stored_jwt_to_headers(context):
    """
    Add the valid jwt to headers
    :param context: behave test context
    """
    context.headers['Authorization'] = f'Bearer {context.values["jwt"]}'
    logging.info('JWT_TO_HEADERS: %s', context.values["jwt"])


@step('I delete all chargers from db')
def delete_all_chargers(context):
    """
    Delete all chargers in db
    :param context: behave test context
    """

    context.execute_steps("""
        Given I get a jwt for email: admin@wallbox.com and password: admin1234
        And the request path "/chargers/"
        And the request headers
        | header_name | header_value     |
        | accept      | application/json |
        And I add jwt to headers in order to authenticate
        When I make a "GET" request
        Then status code is "200"
    """)

    received_body = json.loads(context.request.text)

    for charger in received_body['chargers']:
        context.execute_steps(f"""
        Given I get a jwt for email: admin@wallbox.com and password: admin1234
        And the request path "/chargers/{charger['uid']}"
        And the request headers
        | header_name  | header_value     |
        | accept       | application/json |
        And I add jwt to headers in order to authenticate
        When I make a "DELETE" request
        Then status code is "204"
        """)


@step('I delete all new users from db')
def delete_all_users(context):
    """
    Delete all created users from db
    :param context: behave test context
    """

    context.execute_steps("""
        Given I get a jwt for email: admin@wallbox.com and password: admin1234
        And the request path "/users/"
        And the request headers
        | header_name | header_value     |
        | accept      | application/json |
        And I add jwt to headers in order to authenticate
        When I make a "GET" request
        Then status code is "200"
    """)

    received_body = json.loads(context.request.text)

    for user in received_body['users']:
        if 'new_user' in user['email']:
            context.execute_steps(f"""
            Given I get a jwt for email: admin@wallbox.com and password: admin1234
            And the request path "/users/{user['uid']}"
            And the request headers
            | header_name  | header_value     |
            | accept       | application/json |
            And I add jwt to headers in order to authenticate
            When I make a "DELETE" request
            Then status code is "204"
            """)
