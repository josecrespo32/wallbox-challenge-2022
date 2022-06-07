Feature: Create Chargers feature
  As user I want to be able to add new chargers

  @fixture.check_api_health
  @integration
  # DETECTS BUG: model must be an enumeration, in swagger it is not well documented
  Scenario: Create charger with admin user
    Given I delete all chargers from db
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
    And response body contains "message" field with value "Charger registered"
    And response body contains "charger.uid" field
    And response body contains "charger.serialNumber" field with value "1234567890"
    And response body contains "charger.model" field with value "Pulsar Plus"

  @integration
  Scenario Outline: Create charger with admin user with incorrect data. Missing field <field>. Error

    Examples:
      | field        |
      | serialNumber |
      | model        |

  @integration
  Scenario: Create charger with admin user with incorrect data. Wrong model. Error

  @fixture.check_api_health
  @integration
  Scenario: Create charger with non admin user. Error
    Given I delete all chargers from db
    And I get a jwt for email: user@wallbox.com and password: user1234
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
    Then status code is "401"

  @integration
  Scenario: Create charger without correct auth. Error