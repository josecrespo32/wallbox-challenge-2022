Feature: Delete Users feature
  As an admin user I want to be able to delete users

  @fixture.check_api_health
  @e2e
  Scenario: Delete an admin user with same admin user
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
      "emailConfirmation": "new_admin@wallbox.com",
      "email": "new_admin@wallbox.com",
      "passwordConfirmation": "newadmin1234",
      "password": "newadmin1234",
      "role": "admin"
    }
    """
    When I make a "POST" request
    Then status code is "200"
    And I save "user.uid" field value to context
    Given I get a jwt for email: new_admin@wallbox.com and password: newadmin1234
    And the request path "/users/CONTEXT:user_uid"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "DELETE" request
    Then status code is "204"

  @fixture.check_api_health
  @e2e
  Scenario: Delete an admin user with another admin user
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
      "emailConfirmation": "new_admin@wallbox.com",
      "email": "new_admin@wallbox.com",
      "passwordConfirmation": "newadmin1234",
      "password": "newadmin1234",
      "role": "admin"
    }
    """
    When I make a "POST" request
    Then status code is "200"
    And I save "user.uid" field value to context
    Given I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/users/CONTEXT:user_uid"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "DELETE" request
    Then status code is "403"
    Given I get a jwt for email: new_admin@wallbox.com and password: newadmin1234
    And the request path "/users/CONTEXT:user_uid"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "DELETE" request
    Then status code is "204"

  @fixture.check_api_health
  @integration
  Scenario: Delete an admin user with regular user. Error
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
      "emailConfirmation": "new_admin@wallbox.com",
      "email": "new_admin@wallbox.com",
      "passwordConfirmation": "newadmin1234",
      "password": "newadmin1234",
      "role": "admin"
    }
    """
    When I make a "POST" request
    Then status code is "200"
    And I save "user.uid" field value to context
    Given I get a jwt for email: user@wallbox.com and password: user1234
    And the request path "/users/CONTEXT:user_uid"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "DELETE" request
    Then status code is "401"
    Given I get a jwt for email: new_admin@wallbox.com and password: newadmin1234
    And the request path "/users/CONTEXT:user_uid"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    And I add jwt to headers in order to authenticate
    When I make a "DELETE" request

  @fixture.check_api_health
  @integration
  Scenario: Delete user without correct auth. Error
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
    And I save "user.uid" field value to context
    And the request path "/users/CONTEXT:user_uid"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    When I make a "DELETE" request
    Then status code is "401"