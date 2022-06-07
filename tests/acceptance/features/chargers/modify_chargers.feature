Feature: Modify Chargers feature
  As user I want to be able to modify chargers

  @fixture.check_api_health
  @e2e
  # DETECTS BUG: if serial number starts with 0 although it is a string leading 0 is removed
  Scenario: Modify charger with admin user
    Given I delete all chargers from db
    # CREATE CHARGER
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
    # MODIFY CHARGER
    And I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/chargers/CONTEXT:charger_uid"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And I add jwt to headers in order to authenticate
    And the request body
    """
    {
      "serialNumber": "0987654321",
      "model": "Pulsar Plus"
    }
    """
    When I make a "PUT" request
    Then status code is "200"
    And response body contains "charger.uid" field with value "CONTEXT:charger_uid"
    And response body contains "charger.serialNumber" field with value "987654321"
    And response body contains "charger.model" field with value "Pulsar Plus"

  @integration
  Scenario: Modify charger with non admin user. Error
    Given I delete all chargers from db
    # CREATE CHARGER
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
    # MODIFY CHARGER
    And I get a jwt for email: user@wallbox.com and password: user1234
    And the request path "/chargers/CONTEXT:charger_uid"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And I add jwt to headers in order to authenticate
    And the request body
    """
    {
      "serialNumber": "0987654321",
      "model": "Pulsar Plus"
    }
    """
    When I make a "PUT" request
    Then status code is "401"

  @integration
  Scenario Outline: Modify charger without mandatory fields. Missing <field> field. Error

    Examples:
      | field        |
      | serialNumber |
      | model        |

  @integration
  Scenario: Modify charger to wrong model. Error

  @integration
  Scenario: Modify charger without correct auth. Error