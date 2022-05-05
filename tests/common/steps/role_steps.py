# -*- coding: utf-8 -*-

from behave import step
from common.steps.api_steps import get_login_token
from common.utils.user_utils import get_uid_by_login
from common.utils.context_utils import get_translated_value


@step('the admin requests the creation of the user "{user}" with password "{password}" and "{role}" role')
def user_requests_user_creation(context, user, password, role):
    user = get_translated_value(context, user)
    context.execute_steps(f'''
        When  I launch a "POST" request against "/users" endpoint using this json body and these headers
        """
        {{
          "email": "{user}",
          "emailConfirmation": "{user}",
          "password": "{password}",
          "passwordConfirmation": "{password}",
          "role": "{role}"
        }}
        """
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')
    context.new_user = {"email": user, "password": password, "role": role}
    if context.api_response.status_code == 200:
        context.new_user["uid"] = context.api_response.json()["user"]["uid"]


@step('the admin requests the creation of the "{model}" charger with serial number "{serial_number}"')
@step('the user requests the creation of the "{model}" charger with serial number "{serial_number}"')
def user_requests_charger_creation(context, model, serial_number):
    serial_number = get_translated_value(context, serial_number)
    context.execute_steps(f'''
        When  I launch a "POST" request against "/chargers" endpoint using this json body and these headers
        """
        {{
          "serialNumber": "{serial_number}",
          "model": "{model}"
        }}
        """
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')
    context.new_charger = {"model": model, "serialNumber": int(serial_number)}
    if context.api_response.status_code == 200:
        context.new_charger["uid"] = context.api_response.json()["charger"]["uid"]
    if 'new_chargers_list' in context:
        context.new_chargers_list.append(context.new_charger)
    else:
        context.new_chargers_list = [context.new_charger]


@step('the admin requests the assignation of the just created charger to the just created user')
@step('the admin requests the assignation of the just created charger to the user "{email}"')
@step('the user requests the assignation of the just created charger to the just created user')
def assign_new_charger_to_new_user(context, email=None):
    if email is None:
        email = context.new_user["email"]
        user_uid = context.new_user['uid']
    else:
        context.execute_steps('''
            When  I launch a "GET" request against "/users" endpoint using these headers
            | header_name   | header_value                 |
            | Content-Type  | application/json             |
            | Authorization | Bearer [CONTEXT:login_token] |
        ''')
        user_uid = next(filter(lambda user: user['email'] == email, context.api_response.json()["users"]))['uid']
    context.execute_steps(f'''
        When  I launch a "POST" request against "/chargers/{context.new_charger['uid']}/users/{user_uid}" endpoint using these headers
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')


@step('the admin requests the assignation of the just created chargers to the user "{email}"')
def assign_created_chargers_to_user(context, email):
    for charger in context.new_chargers_list:
        context.new_charger = charger
        assign_new_charger_to_new_user(context, email)


@step('the new user info retrieved by itself is the same as those requested in its creation')
def check_new_user_data(context):
    context.new_user.pop("password")
    context.execute_steps(f'''
        When  I launch a "GET" request against "/users/{context.new_user['uid']}" endpoint using these headers
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')
    assert context.new_user == context.api_response.json(), \
        "ERROR. The requested info is not the same as the stored one:\n" \
        f"Requested: {context.new_user}\n" \
        f"Stored: {context.api_response.json()}"


@step('the charger data stored in the application is the same as the requested in its creation')
def check_new_charger_data(context):
    context.execute_steps(f'''
        When  I launch a "GET" request against "/chargers/{context.new_charger['uid']}" endpoint using these headers
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')
    assert context.new_charger == context.api_response.json(), \
        "ERROR. The requested info is not the same as the stored one:\n" \
        f"Requested: {context.new_charger}\n" \
        f"Stored: {context.api_response.json()}"


@step('the admin can check the user "{email}" info')
def get_user_info_as_admin(context, email, not_in=False):
    if email is None:
        email = context.new_user["email"]
    context.execute_steps('''
        When  I launch a "GET" request against "/users" endpoint using these headers
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')
    emails = [user["email"] for user in context.api_response.json()["users"]]
    if not_in:
        assert email not in emails, "The user does exist and is visible for the admin"
    else:
        assert email in emails, "The user does not exist or is not visible for the admin"


@step('the admin can not check the just created user info')
def not_get_user_info_as_admin(context):
    get_user_info_as_admin(context, email=None, not_in=True)


@step('the user "user@wallbox.com" can not check the just created user info')
def not_get_user_info_as_default_user(context):
    get_login_token(context, context.params["users"]["user@wallbox.com"], "user@wallbox.com")
    get_user_info_as_admin(context, email=None, not_in=True)


@step('the just created user can see the info of the just created charger')
def user_can_see_charger(context, email=None, password=None, can_not=False):
    if email is None:
        email = context.new_user["email"]
    if password is None:
        password = context.new_user['password']
    context.execute_steps(f'''
        Given the user "{email}" gets a new valid token using password "{password}"
        When  I launch a "GET" request against "/chargers/{context.new_charger['uid']}" endpoint using these headers
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')
    if can_not:
        assert context.api_response.status_code != 200 and \
            context.new_charger['serialNumber'] not in context.api_response.json(), \
            'ERROR: The user can check the info of the charger'
    else:
        assert context.api_response.status_code == 200 and \
               context.api_response.json()['serialNumber'] == context.new_charger['serialNumber'] and \
               context.new_user in context.api_response.json()['users'], \
               'ERROR: The user can not check the info of the charger'


@step('the just created user can not see the info of the just created charger')
def user_can_not_see_charger(context):
    user_can_see_charger(context, email=None, password=None, can_not=True)


@step('the user "user@wallbox.com" can see the info of the just created charger')
def default_user_can_see_charger(context, can_not=False):
    uid = get_uid_by_login(context.app_server, "user@wallbox.com", context.params["users"]["user@wallbox.com"])
    context.new_user = {"uid": uid,
                        "email": "user@wallbox.com",
                        "password": context.params["users"]["user@wallbox.com"],
                        "role": "user"}
    user_can_see_charger(context, "user@wallbox.com", context.params["users"]["user@wallbox.com"], can_not)


@step('the user "user@wallbox.com" can not see the info of the just created charger')
def default_user_can_not_see_charger(context):
    default_user_can_see_charger(context, can_not=True)


@step('the charger serial number of the creation attempt can not be found by the admin "admin@wallbox.com"')
def default_admin_cant_find_charger(context):
    context.execute_steps(f'''
        Given the user "admin@wallbox.com" gets a new valid token using password "{context.params['users']['admin@wallbox.com']}"
        When  I launch a "GET" request against "/chargers" endpoint using these headers
        | header_name   | header_value                 |
        | Content-Type  | application/json             |
        | Authorization | Bearer [CONTEXT:login_token] |
    ''')
    serial_numbers = [charger["serialNumber"] for charger in context.api_response.json()["chargers"]]
    assert context.new_charger['serialNumber'] not in serial_numbers, \
        f'''The serial number "{context.new_charger['serialNumber']}" is registered'''
    assert context.new_charger['serialNumber'] not in serial_numbers, \
        f'''The serial number "{context.new_charger['serialNumber']}" is registered'''
