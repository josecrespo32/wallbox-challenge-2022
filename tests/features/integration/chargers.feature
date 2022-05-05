# -*- coding: utf-8 -*-


Feature: CHARGERS ENDPOINT
  As an user with admin or user role
  I want to test the chargers endpoint
  and all its methods and scenarios


### GET ####

  @BUG_001
  Scenario: CHARGERS - CHARGERS - GET method returns OK
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "GET" request against "/chargers" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_get_chargers.json" json schema


### GET BY UID ####


  Scenario: CHARGERS - GET method returns OK over a valid uid
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "GET" request against "/chargers/[CONTEXT:valid_charger_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_get_chargers_uid.json" json schema


  Scenario: CHARGERS - GET method fails over a uid with invalid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "GET" request against "/chargers/.*wijd^+728nc822fjsni828h%" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_get_chargers_invalid_uid.json" json schema


  Scenario: CHARGERS - GET method fails over a non-existent uid with a right uid format
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "GET" request against "/chargers/XXXXXXXXXXXXXXXXXXXXXXXXXX" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_get_chargers_not_found_uid.json" json schema


### POST ###

  #['Pulsar Plus', 'Commander', 'Quasar']
  Scenario: CHARGERS - POST method returns OK with the mandatory json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/chargers" endpoint using this json body and these headers
      """
      {
        "serialNumber": "[RANDOM_INT]",
        "model": "Commander"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_post_chargers.json" json schema


  Scenario Outline: CHARGERS - POST method fails without some of the mandatory json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/chargers" endpoint using this json body and these headers
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
      | without_field | json_body                        |
      | serialNumber  | {"model": "Commander"}           |
      | model         | {"serialNumber": "[RANDOM_INT]"} |


  Scenario: CHARGERS - POST method fails when the serialNumber is not a number
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/chargers" endpoint using this json body and these headers
      """
      {
        "serialNumber": "jnslknqslkc",
        "model": "Commander"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_chargers_invalid_serial.json" json schema


  Scenario: CHARGERS - POST method fails when the the model is not one of the valid values
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "POST" request against "/chargers" endpoint using this json body and these headers
      """
      {
        "serialNumber": "[RANDOM_INT]",
        "model": "invalid_model"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_post_chargers_invalid_model.json" json schema


### PUT ###


  Scenario: CHARGERS - PUT method returns OK with all its possible json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "PUT" request against "/chargers/[CONTEXT:valid_charger_uid]" endpoint using this json body and these headers
      """
      {
        "serialNumber": "[RANDOM_INT]",
        "model": "Pulsar Plus"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "200"
    And   the body response matches "./resources/json_schemas/response_put_chargers.json" json schema


  Scenario Outline: CHARGERS - PUT method returns OK with only one of its possible json body params
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "PUT" request against "/chargers/[CONTEXT:valid_charger_uid]" endpoint using this json body and these headers
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
    And   the body response matches "./resources/json_schemas/response_put_chargers.json" json schema
    Examples: <param>
    | param        | value        |
    | serialNumber | [RANDOM_INT] |
    | model        | Pulsar Plus  |


  Scenario: CHARGERS - PUT method fails when the serialNumber is not a number
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "PUT" request against "/chargers/[CONTEXT:valid_charger_uid]" endpoint using this json body and these headers
      """
      {
        "serialNumber": "jnslknqslkc"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_put_chargers_invalid_serial.json" json schema


  Scenario: CHARGERS - PUT method fails when the the model is not one of the valid values
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "PUT" request against "/chargers/[CONTEXT:valid_charger_uid]" endpoint using this json body and these headers
      """
      {
        "model": "invalid_model"
      }
      """
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    And   the response status code is "400"
    And   the body response matches "./resources/json_schemas/response_put_chargers_invalid_model.json" json schema


### DELETE ###


  Scenario: CHARGERS - DELETE method returns OK over a valid uid
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    And   a new charger is created to test over
    When  I launch a "DELETE" request against "/chargers/[CONTEXT:valid_charger_uid]" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response status code is "204"


  Scenario: CHARGERS - DELETE method fails over a non existing uid
    Given the app is up and running
    And   I get a new valid token of the admin "admin@wallbox.com" using password "admin1234"
    When  I launch a "DELETE" request against "/chargers/XXXXXXXXXXXXXXXXXXXXXXXXXX" endpoint using these headers
      | header_name   | header_value                 |
      | Content-Type  | application/json             |
      | Authorization | Bearer [CONTEXT:login_token] |
    Then  the response should come with the header "content-type" set to "application/json; charset=utf-8"
    Then  the response status code is "404"
    And   the body response matches "./resources/json_schemas/response_delete_chargers_not_found.json" json schema
