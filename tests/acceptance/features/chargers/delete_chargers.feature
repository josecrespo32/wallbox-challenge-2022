Feature: Delete Chargers feature
  As user I want to be able to delete chargers

  @fixture.check_api_health
  @e2e
  Scenario: Delete a charger with admin user
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
    And I save "charger.uid" field value to context
    And I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/chargers/CONTEXT:charger_uid"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "DELETE" request
    Then status code is "204"

  @integration
  Scenario: Delete a charger with non admin user. Error

  @integration
  Scenario: Delete a charger without correct auth. Error