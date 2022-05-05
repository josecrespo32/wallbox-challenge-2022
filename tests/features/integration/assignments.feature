# -*- coding: utf-8 -*-


Feature: ASSIGNMENTS ENDPOINT
  As an user with admin or user role
  I want to test the assignments endpoint
  and all its methods and scenarios


### POST ###


  Scenario: ASSIGNMENTS - POST method returns OK with the mandatory json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    And   a new charger is created to test over
    When  I launch a "POST" request against "/chargers/[CONTEXT:valid_charger_uid]/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_post_chargers_users.json" json schema


  Scenario: ASSIGNMENTS - POST method fails over a non-existent charger uid with a right uid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "POST" request against "/chargers/XXXXXXXXXXXXXXXXXXXXXXXXXX/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_post_assignment_not_found_charger_uid.json" json schema


  Scenario: ASSIGNMENTS - POST method fails over a non-existent user uid with a right uid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "POST" request against "/chargers/[CONTEXT:valid_charger_uid]/users/XXXXXXXXXXXXXXXXXXXXXXXXXX" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_post_assignment_not_found_user_uid.json" json schema


  Scenario: ASSIGNMENTS - POST method fails over a charger uid with invalid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "POST" request against "/chargers/.*wijd^+728nc822fjsni828h%/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_assignment_invalid_charger_uid.json" json schema


  Scenario: ASSIGNMENTS - POST method fails over a user uid with invalid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "POST" request against "/chargers/[CONTEXT:valid_charger_uid]/users/.*wijd^+728nc822fjsni828h%" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_assignment_invalid_user_uid.json" json schema


### DELETE ###


  Scenario: ASSIGNMENTS - POST method returns OK with the mandatory json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    And   a new charger is created to test over
    And   the just created charger is assigned to the just created user
    When  I launch a "DELETE" request against "/chargers/[CONTEXT:valid_charger_uid]/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"


  Scenario: ASSIGNMENTS - POST method fails over a non-existent charger uid with a right uid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "DELETE" request against "/chargers/XXXXXXXXXXXXXXXXXXXXXXXXXX/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_delete_assignment_not_found_charger_uid.json" json schema


  Scenario: ASSIGNMENTS - POST method fails over a non-existent user uid with a right uid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "DELETE" request against "/chargers/[CONTEXT:valid_charger_uid]/users/XXXXXXXXXXXXXXXXXXXXXXXXXX" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_delete_assignment_not_found_user_uid.json" json schema


  Scenario: ASSIGNMENTS - POST method fails over a charger uid with invalid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new user is created to test over
    When  I launch a "DELETE" request against "/chargers/.*wijd^+728nc822fjsni828h%/users/[CONTEXT:valid_user_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_delete_assignment_invalid_charger_uid.json" json schema


  Scenario: ASSIGNMENTS - POST method fails over a user uid with invalid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "DELETE" request against "/chargers/[CONTEXT:valid_charger_uid]/users/.*wijd^+728nc822fjsni828h%" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_delete_assignment_invalid_user_uid.json" json schema
