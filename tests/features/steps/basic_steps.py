import json
import re

import requests
from behave import *

from utils import *

logger = logging.getLogger(__name__)


@step('the app endpoint is the configured one')
def step_impl(context):
    context.endpoint = f"{context.tests_config['app']['protocol']}://" \
                       f"{context.tests_config['app']['host']}:"  \
                       f"{context.tests_config['app']['port']}"


@step('a "{method}" HTTP request is sent to resource "{resource}"')
@step('a "{method}" HTTP request is sent to resource "{resource}" with parameters')
def step_impl(context, method, resource):
    parsed_resource = parse_string(context, resource)
    auth_header = {'Authorization': f'Bearer {context.jwt}'} if hasattr(context, 'jwt') else None

    if context.text:
        json_data = json.loads(parse_string(context, context.text))
    elif context.table:
        json_data = {row['param']: parse_string(context, row['value'])
                     for row in context.table}
    else:
        json_data = None

    logger.debug(f'{method} {parsed_resource} --> {json_data}')

    context.response = requests.request(method=method,
                                        headers=auth_header,
                                        url=f'{context.endpoint}{parsed_resource}',
                                        json=json_data)

    logger.debug(f"Response [{context.response.status_code}] {context.response.text if context.response.text else ''}")


@step('the HTTP response status is "{response_status}"')
def step_impl(context, response_status):
    assert context.response.status_code == int(response_status), \
        f'Request returned and unexpected status code: {context.response.status_code}'


@step('the HTTP response body is')
def step_impl(context):
    assert context.response.text == context.text, \
        f"{context.response.text} is not the expected one: {context.text}"


@step('the HTTP response body contains')
def step_impl(context):
    for row in context.table:
        received_parsed_response = get_json_entry_from_path(context.response.json(), row['param'])
        table_parsed_value = parse_string(context, row['value'])
        assert received_parsed_response == table_parsed_value, \
            f"Param {received_parsed_response} value is not the expected one: {table_parsed_value}"


@step('the HTTP response body contains a valid {key}')
def step_impl(context, key):
    validation_regexps = {
        'UID': '[A-Z0-9]{26}',
        'JWT': '^[A-Za-z0-9\\-_=]+\.[A-Za-z0-9\\-_=]+(\.[A-Za-z0-9\-_.+=]+)?$',
    }

    assert re.match(validation_regexps[key], context.response.json()[key.lower()]), \
        'The key does not match the expected regular expression.'

    setattr(context, key.lower(), context.response.json()[key.lower()])
