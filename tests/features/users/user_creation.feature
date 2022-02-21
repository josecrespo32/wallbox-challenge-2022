Feature: User creation
  Test user creation.
  Signin is required.
  Users with "admin" role can update details from every other user.
  Users with "user" role can only update its own details.


  Scenario: Create a new user with a user with "admin" role
    Successful user creation with a user with "admin" role.
    BUG: "201 Created" expected.
    BUG: Definition in Swagger is incomplete. Missing mandatory parameters: "emailConfirmation" and "passwordConfirmation".
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I sign in as "admin" user
     When a "POST" HTTP request is sent to resource "/users" with parameters
          | param                | value                        |
          | email                | CONF:users.user_new.email    |
          | emailConfirmation    | CONF:users.user_new.email    |
          | password             | CONF:users.user_new.password |
          | passwordConfirmation | CONF:users.user_new.password |
          | role                 | CONF:users.user_new.role     |
     # Then the HTTP response status is "201"
      And the HTTP response body contains
          | param      | value                     |
          | message    | User registered           |
          | user.email | CONF:users.user_new.email |
          | user.role  | CONF:users.user_new.role  |


  Scenario: User creation missing authentication returns error
    User creation request missing authentication returns error.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "users" database
     When a "POST" HTTP request is sent to resource "/users" with parameters
          | param                | value                        |
          | email                | CONF:users.user_new.email    |
          | emailConfirmation    | CONF:users.user_new.email    |
          | password             | CONF:users.user_new.password |
          | passwordConfirmation | CONF:users.user_new.password |
          | role                 | CONF:users.user_new.role     |
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |


  Scenario: Users with "user" role can not create new users
    User creation request with a user with "user" role returns error.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I sign in as "user" user
     When a "POST" HTTP request is sent to resource "/users" with parameters
          | param                | value                       |
          | email                | CONF:users.user_new.email    |
          | emailConfirmation    | CONF:users.user_new.email    |
          | password             | CONF:users.user_new.password |
          | passwordConfirmation | CONF:users.user_new.password |
          | role                 | CONF:users.user_new.role     |
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                    |
          | status  | 401                      |
          | message | Insufficient permissions |


  @wip
  Scenario: Create a new user with a user with "admin" role with missing body returns error
    User creation request with a user with "admin" role and missing body returns error.

  @wip
  Scenario: Create a new user with a user with "admin" role with missing parameters returns error
    User creation request with a user with "admin" role and missing parameters returns error.

  @wip
  Scenario: Create a new user with a user with "admin" role with incorrect parameter values returns error
    User creation request with a user with "admin" role and incorrect parameter values returns error.

  @wip
  Scenario: Create a new user with a user with "admin" role with existing email returns error
    User creation request with a user with "admin" role to an already existing email returns error.
