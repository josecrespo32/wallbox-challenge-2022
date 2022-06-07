Feature: List Chargers feature
  As user I want to be able to list chargers

    # GET

  @fixture.check_api_health
  @integration
  Scenario: List chargers with admin user with correct auth. All chargers returned
    Given I delete all chargers from db
    And I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/chargers/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "GET" request
    Then status code is "200"
    And json response body is the following
    """
    {"chargers": []}
    """

  @fixture.check_api_health
  @integration
  Scenario: List chargers with non admin user with correct auth. Only user's chargers returned
    Given I delete all chargers from db
    And I get a jwt for email: user@wallbox.com and password: user1234
    And the request path "/chargers/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "GET" request
    Then status code is "200"
    And json response body is the following
    """
    {"chargers": []}
    """

  @fixture.check_api_health
  @integration
  Scenario: List chargers without correct auth. Error
    Given the request host "http://localhost:3000"
    And the request path "/chargers/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    When I make a "GET" request
    Then status code is "401"