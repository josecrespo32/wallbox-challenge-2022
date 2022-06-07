Feature: List Users feature
  As user I want to be able to list users

  @fixture.check_api_health
  @e2e
  Scenario: List users with admin user. Admin and non admin users returned
    Given I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/users/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "GET" request
    Then status code is "200"
    And response body contains "users.0.uid" field
    And response body contains "users.0.email" field with value "admin@wallbox.com"
    And response body contains "users.0.role" field with value "admin"
    And response body contains "users.1.uid" field
    And response body contains "users.1.email" field with value "user@wallbox.com"
    And response body contains "users.1.role" field with value "user"

  @fixture.check_api_health
  @integration
  Scenario: List users with non admin user. Non admin users returned
    Given I get a jwt for email: user@wallbox.com and password: user1234
    And the request path "/users/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "GET" request
    Then status code is "200"
    And response body contains "users.0.uid" field
    And response body contains "users.0.email" field with value "user@wallbox.com"
    And response body contains "users.0.role" field with value "user"


  @fixture.check_api_health
  @integration
  Scenario: List users without correct auth. Error
    Given the request host "http://localhost:3000"
    And the request path "/users/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    When I make a "GET" request
    Then status code is "401"