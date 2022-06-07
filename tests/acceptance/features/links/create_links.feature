Feature: Create Links feature
  As user I want to be able to link a charger to a user

  @fixture.check_api_health
  @e2e
  Scenario: Link charger to admin user with admin user
    Given I delete all chargers from db
    #CREATE CHARGER
    And I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/chargers/"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And I add jwt to headers in order to authenticate
    And the request body
    """
    {
      "serialNumber": "1234567890",
      "model": "Pulsar Plus"
    }
    """
    When I make a "POST" request
    Then status code is "200"
    And I save "charger.uid" field value to context
    # GET USER UID
    Given I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/users/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "GET" request
    Then status code is "200"
    And I save "users.0.uid" field value to context
    # CREATE LINK
    And I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/chargers/CONTEXT:charger_uid/users/CONTEXT:users_0_uid"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "POST" request
    Then status code is "200"
    And response body contains "message" field with value "Allowed user to access charger"
    And response body contains "charger.uid" field with value "CONTEXT:charger_uid"
    And response body contains "charger.serialNumber" field with value "1234567890"
    And response body contains "charger.model" field with value "Pulsar Plus"
    And response body contains "charger.users.0.uid" field with value "CONTEXT:users_0_uid"
    And response body contains "charger.users.0.email" field with value "admin@wallbox.com"

  @e2e
  Scenario: Link charger to non admin user with admin user

  @e2e
  Scenario: Link charger to non admin user with non admin user

  @integration
  Scenario: Link charger to admin user with non admin user. Error

  @integration
  Scenario: Link charger to user without correct auth. Error
