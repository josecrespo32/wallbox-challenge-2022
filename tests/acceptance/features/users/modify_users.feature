Feature: Modify Users feature
  As an admin user I want to be able to modify users

  @fixture.check_api_health
  @e2e
  # DETECTS BUG: password cannot be modified without modifying email too
  Scenario Outline: Modify non admin user with admin user. Change <field>
    Given I delete all new users from db
    # CREATE USER
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
    And I save "user.uid" field value to context
    # MODIFY USER
    And I get a jwt for email: admin@wallbox.com and password: admin1234
    And the request path "/users/CONTEXT:user_uid"
    And the request headers
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    And I add jwt to headers in order to authenticate
    And the request body
    """
    {
      "email": "<email_value>",
      "password": "<password_value>",
      "role": "user"
    }
    """
    When I make a "PUT" request
    Then status code is "200"
    And response body contains "user.email" field with value "<email_value>"
    And response body contains "user.role" field with value "user"

    Examples:
      | field    | email_value           | password_value |
      | email    | new_user1@wallbox.com | newuser1234    |
      | password | new_user1@wallbox.com | newuser4321    |

  @integration
  Scenario Outline: Modify admin user with non admin user. Change <field>. Error

    Examples:
      | field    |
      | email    |
      | password |

  @integration
  Scenario: Modify admin user with admin user to change to user type "user"

  @integration
  Scenario: Modify non admin user with admin user to change to user type "admin"

  @integration
  Scenario: Modify user without correct auth. Error
