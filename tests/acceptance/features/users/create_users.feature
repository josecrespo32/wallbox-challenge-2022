Feature: Create Users feature
  As an admin user I want to be able to add new users

  @fixture.check_api_health
  @e2e
  # DETECTS BUG: mandatory parameters: emailConfirmation and passwordConfirmation are not documented in swagger
  # DETECTS BUG: Password format not documented in swagger, only alphanumeric chars allowed
  Scenario: Create non admin user with admin user
    Given I delete all new users from db
    And I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/users/"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And I add jwt to headers in order to authenticate
    And the request body
    """
    {
      "emailConfirmation": "new_user@wallbox.com",
      "email": "new_user@wallbox.com",
      "passwordConfirmation": "newuser1234",
      "password": "newuser1234",
      "role": "user"
    }
    """
    When I make a "POST" request
    Then status code is "200"
    And response body contains "message" field with value "User registered"
    And response body contains "user.uid" field
    And response body contains "user.email" field with value "new_user@wallbox.com"

  @fixture.check_api_health
  @integration
  Scenario: Create admin user with non admin user. Error
    Given I delete all new users from db
    And I get a jwt for email: user@wallbox.com and password: user1234
    And the request path "/users/"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And I add jwt to headers in order to authenticate
    And the request body
    """
    {
      "email": "new_admin@wallbox.com",
      "emailConfirmation": "new_admin@wallbox.com",
      "password": "newadmin1234",
      "passwordConfirmation": "newadmin1234",
      "role": "admin"
    }
    """
    When I make a "POST" request
    Then status code is "401"

  @fixture.check_api_health
  @integration
  Scenario: Create user without correct auth. Error
    Given the request path "/users/"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And the request body
    """
    {
      "emailConfirmation": "new_user@wallbox.com",
      "email": "new_user@wallbox.com",
      "passwordConfirmation": "newuser1234",
      "password": "newuser1234",
      "role": "user"
    }
    """
    When I make a "POST" request
    Then status code is "401"