from behave import *


@step('the app is up and ready for testing')
def step_impl(context):
    context.execute_steps(f"""
        Given the app endpoint is the configured one
         When a "GET" HTTP request is sent to resource "/"
         Then the HTTP response status is "200"
          And the HTTP response body contains
              | param   | value                                         |
              | message | Wallbox Challenge API REST is up and running! |
        """)


@step('I sign in as "{user}" user')
def step_impl(context, user):
    context.execute_steps(f"""
        Given a "POST" HTTP request is sent to resource "/signin" with parameters
              | param    | value                      |
              | email    | CONF:users.{user}.email    |
              | password | CONF:users.{user}.password |
         Then the HTTP response status is "200"
          And the HTTP response body contains a valid UID
          And the HTTP response body contains a valid JWT
        """)


@step('I create the user "{user}" from configuration')
def step_impl(context, user):
    context.execute_steps(f"""
       Given I sign in as "admin" user
        When a "POST" HTTP request is sent to resource "/users" with parameters
             | param                | value                      |
             | email                | CONF:users.{user}.email    |
             | emailConfirmation    | CONF:users.{user}.email    |
             | password             | CONF:users.{user}.password |
             | passwordConfirmation | CONF:users.{user}.password |
             | role                 | CONF:users.{user}.role     |
       # Then the HTTP response status is "201"
         And I enrich the users list
        """)
    context.jwt = None


@step('I enrich the users list')
def step_impl(context):
    context.execute_steps(f"""
        Given the app is up and ready for testing
          And I sign in as "admin" user
         When a "GET" HTTP request is sent to resource "/users"
         Then the HTTP response status is "200"
        """)
    for db_user in context.response.json().get('users'):
        for cf_user_name, cf_user_data in context.tests_config.get('users').items():
            if db_user.get('email') == cf_user_data.get('email'):
                cf_user_data['uid'] = db_user.get('uid')
    context.jwt = None


@step('I create the charger "{charger}" from configuration')
def step_impl(context, charger):
    context.execute_steps(f"""
       Given I sign in as "admin" user
        When a "POST" HTTP request is sent to resource "/chargers" with parameters
             | param        | value                                |
             | serialNumber | CONF:chargers.{charger}.serialNumber |
             | model        | CONF:chargers.{charger}.model        |
       # Then the HTTP response status is "201"
         And I enrich the chargers list
        """)
    context.jwt = None


@step('I enrich the chargers list')
def step_impl(context):
    context.execute_steps(f"""
        Given the app is up and ready for testing
          And I sign in as "admin" user
         When a "GET" HTTP request is sent to resource "/chargers"
         Then the HTTP response status is "200"
        """)
    for db_charger in context.response.json().get('chargers'):
        for cf_charger_name, cf_charger_data in context.tests_config.get('chargers').items():
            if db_charger.get('serialNumber') == cf_charger_data.get('serialNumber'):
                cf_charger_data['uid'] = db_charger.get('uid')
    context.jwt = None


@step('I wipe the "{items}" database')
def step_impl(context, items):
    context.execute_steps(f"""
        Given I enrich the {items} list
        """)
    for item in context.response.json().get(items):
        if (items == 'users' and item.get('email').startswith('user_')) or items == 'chargers':
            context.execute_steps(f"""
                Given I sign in as "admin" user
                 When a "DELETE" HTTP request is sent to resource "/{items}/{item.get('uid')}"
                 Then the HTTP response status is "204"
                """)
    context.jwt = None


@step('I link user "{user}" to charger "{charger}"')
def step_impl(context, user, charger):
    context.execute_steps(f"""
        Given I sign in as "admin" user
         When a "POST" HTTP request is sent to resource "/chargers/CONF:chargers.{charger}.uid/users/CONF:users.{user}.uid"
         Then the HTTP response status is "200"
        """)
    context.jwt = None
