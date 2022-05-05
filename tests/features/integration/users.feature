# -*- coding: utf-8 -*-


Feature: USERS ENDPOINT
  As an user with admin or user role
  I want to test the users endpoint
  and all its methods and scenarios


### GET ####


  Scenario: USERS - GET method returns OK
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "GET" request against "/users" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_get_users.json" json schema


### GET BY UID ####


  Scenario: USERS - GET method returns OK over a valid uid
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   I get a valid user uid to query over
    When  I launch a "GET" request against "/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_get_users_uid.json" json schema


  Scenario: USERS - GET method fails over a uid with invalid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "GET" request against "/users/.*wijd^+728nc822fjsni828h%" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_get_users_invalid_uid.json" json schema

  @COMMENT_003
  Scenario: USERS - GET method fails over a non-existent uid with a right uid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "GET" request against "/users/XXXXXXXXXXXXXXXXXXXXXXXXXX" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_get_users_not_found_uid.json" json schema


### POST ###

  @COMMENT_001
  Scenario: USERS - POST method returns OK with the mandatory json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/users" endpoint using this json body and these headers
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
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_post_users.json" json schema

  @COMMENT_002
  Scenario Outline: USERS - POST method fails without some of the mandatory json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/users" endpoint using this json body and these headers
      """
      <json_body>
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_without_mandatory_field.json" json schema
    Examples: without <without_field>
      | without_field        | json_body                                                                                                                                                   |
      | email                | {"emailConfirmation": "[RANDOM]@example.com","password": "secretPassword1234","passwordConfirmation": "secretPassword1234","role": "user"}                  |
      | emailConfirmation    | {"email": "[RANDOM]@example.com","password": "secretPassword1234","passwordConfirmation": "secretPassword1234","role": "user"}                              |
      | password             | {"email": "[RANDOM]@example.com","emailConfirmation": "[RANDOM]@example.com","passwordConfirmation": "secretPassword1234","role": "user"}                   |
      | passwordConfirmation | {"email": "[RANDOM]@example.com","emailConfirmation": "[RANDOM]@example.com","password": "secretPassword1234","role": "user"}                               |
      | role                 | {"email": "[RANDOM]@example.com","emailConfirmation": "[RANDOM]@example.com","password": "secretPassword1234","passwordConfirmation": "secretPassword1234"} |


  Scenario Outline: USERS - POST method fails when the email has not an email format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/users" endpoint using this json body and these headers
      """
      {
        "email": "<email>",
        "emailConfirmation": "<email>",
        "password": "secretPassword1234",
        "passwordConfirmation": "secretPassword1234",
        "role": "user"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_users_invalid_email.json" json schema
    Examples: <label>
      | label                      | email                  |
      | email with no domain       | aabbcc_fake@.com       |
      | email with no local-part   | @example.com           |
      | special char in TLD        | testuser1@ex_ample.com |
      | blank spaces in local-part | test user1@gmail.com   |
      | blank spaces in domain     | testuser1@e xample.com |


  Scenario: USERS - POST method fails when emailConfirmation does not match email
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/users" endpoint using this json body and these headers
      """
      {
        "email": "[RANDOM]@example.com",
        "emailConfirmation": "[RANDOM]@exampleS.com",
        "password": "secretPassword1234",
        "passwordConfirmation": "secretPassword1234",
        "role": "user"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_users_unmatching_email.json" json schema


  Scenario: USERS - POST method fails when passwordConfirmation does not match password
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/users" endpoint using this json body and these headers
      """
      {
        "email": "[RANDOM]@example.com",
        "emailConfirmation": "[RANDOM]@example.com",
        "password": "secretPassword1234",
        "passwordConfirmation": "secretPassword123",
        "role": "user"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_users_unmatching_password.json" json schema


  Scenario: USERS - POST method fails with an invalid role value
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/users" endpoint using this json body and these headers
      """
      {
        "email": "[RANDOM]@example.com",
        "emailConfirmation": "[RANDOM]@example.com",
        "password": "secretPassword1234",
        "passwordConfirmation": "secretPassword1234",
        "role": "invalid_role"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_users_invalid_role.json" json schema


### PUT ###


  Scenario: USERS - PUT method returns OK with all its possible json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "PUT" request against "/users/[CONTEXT:valid_user_uid]" endpoint using this json body and these headers
      """
      {
        "email": "[RANDOM]@example.com",
        "password": "1234secretPassword",
        "role": "admin"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_put_users.json" json schema


  Scenario Outline: USERS - PUT method returns OK with only one of its possible json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "PUT" request against "/users/[CONTEXT:valid_user_uid]" endpoint using this json body and these headers
      """
      {
        "<param>": "<value>"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_put_users.json" json schema
    Examples: <param>
    | param    | value                |
    | email    | [RANDOM]@example.com |
    | password | 1234secretPassword   |
    | role     | admin                |


  Scenario Outline: USERS - PUT method fails when the email has not an email format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "PUT" request against "/users/[CONTEXT:valid_user_uid]" endpoint using this json body and these headers
      """
      {
        "email": "<email>"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_put_users_invalid_email.json" json schema
    Examples: <label>
      | label                      | email                  |
      | email with no domain       | aabbcc_fake@.com       |
      | email with no local-part   | @example.com           |
      | special char in TLD        | testuser1@ex_ample.com |
      | blank spaces in local-part | test user1@gmail.com   |
      | blank spaces in domain     | testuser1@e xample.com |


  Scenario: USERS - PUT method fails with an invalid role value
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "PUT" request against "/users/[CONTEXT:valid_user_uid]" endpoint using this json body and these headers
      """
      {
        "role": "invalid_role"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_put_users_invalid_role.json" json schema


### DELETE ###


  Scenario: USERS - DELETE method returns OK over a valid uid
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "DELETE" request against "/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response status code is "204"


  Scenario: USERS - DELETE method fails over a non existing uid
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "DELETE" request against "/users/XXXXXXXXXXXXXXXXXXXXXXXXXX" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    Then  the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_delete_users_not_found.json" json schema
