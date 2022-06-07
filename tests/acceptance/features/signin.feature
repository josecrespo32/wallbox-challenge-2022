Feature: Singin endpoint feature
  As a user I want to be able to signin to get and auth token

  @fixture.check_api_health
  @integration
  Scenario: Sing in as admin user
    Given the request host "http://localhost:3000"
    And the request path "/signin"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And the request body
    """
    {
      "email": "admin@wallbox.com",
      "password": "admin1234"
    }
    """
    When I make a "POST" request
    Then status code is "200"
    And response body contains "uid" field
    And response body contains "email" field with value "admin@wallbox.com"
    And response body contains "jwt" field

  @fixture.check_api_health
  @integration
  Scenario: Sing in as non admin user
    Given the request host "http://localhost:3000"
    And the request path "/signin"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And the request body
    """
    {
      "email": "user@wallbox.com",
      "password": "user1234"
    }
    """
    When I make a "POST" request
    Then status code is "200"
    And response body contains "uid" field
    And response body contains "email" field with value "user@wallbox.com"
    And response body contains "jwt" field