# -*- coding: utf-8 -*-


Feature: SIGNIN ENDPOINT
  As an user with admin or user role
  I want to test the signin endpoint
  and all its methods and scenarios


### POST ####


  Scenario: SIGNIN - POST method returns OK
    Given the app is up and running
    When  I launch a "POST" request against "/signin" endpoint using this json body and these headers
      """
      {
        "email": "admin@wallbox.com",
        "password": "admin1234"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_post_signin.json" json schema


  Scenario Outline: SIGNIN - POST method fails with an invalid password
    Given the app is up and running
    When  I launch a "POST" request against "/signin" endpoint using this json body and these headers
      """
      {
        "email": "<email>",
        "password": "<password>"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "401"
    And   the body response matches "./resources/json_schemas/response_post_signin_invalid_user_pwd.json" json schema
    Examples: wrong <label>
    | label    | email             | password         |
    | user     | invalid@user.es   | admin1234        |
    | password | admin@wallbox.com | invalid_password |


  Scenario Outline: SIGNIN - POST method fails without some of the mandatory json body params
    Given the app is up and running
    When  I launch a "POST" request against "/signin" endpoint using this json body and these headers
      """
      <json_body>
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_without_mandatory_field.json" json schema
    Examples: without <without_field>
      | without_field | json_body                      |
      | email         | {"password": "admin1234"}      |
      | password      | {"email": "admin@wallbox.com"} |
