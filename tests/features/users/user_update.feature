Feature: User update
  Test user details update.
  Signin is required.
  Users with "admin" role can update details from every other user.
  Users with "user" role can only update its own details.


  Scenario: User with "user" role updates its own details
    User with "user" role can update its own details.
    BUG: PUT is acting as PATCH.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I create the user "user_new" from configuration
      And I sign in as "user_new" user
     When a "PUT" HTTP request is sent to resource "/users/CONTEXT:uid" with parameters
          | param | value                      |
          | email | user_new_email@example.com |
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param      | value                      |
          | message    | User updated               |
          | user.uid   | CONTEXT:uid                |
          | user.email | user_new_email@example.com |
          | user.role  | CONF:users.user_new.role   |


  @wip
  Scenario: User with "admin" role updates its own details
    User with "admin" role can update its own details.

  @wip
  Scenario: User with "admin" role updates the details of another user with "user" role
    User with "admin" role can update the details of a user with "user" role.

  @wip
  Scenario: User with "admin" role can not update the details of another user with "admin" role
    User with "admin" role can not update the details of another user with "admin" role.

  @wip
  Scenario: User with "user" role can not update the details of another user with "admin" role
    User with "user" role can not update the details of another user with "admin" role

  @wip
  Scenario: User with "user" role can not update the details of another user with "user" role
    User with "user" role can not update the details of another user with "user" role

  @wip
  Scenario: User with "admin" role updating the details of another user with missing body returns error
    User update request with a user with "admin" role and missing body returns error.

  @wip
  Scenario: User with "admin" role updating the details of another user with missing parameters returns error
    User update request with a user with "admin" role and missing parameters returns error.

  @wip
  Scenario: User with "admin" role updating the details of another user with incorrect parameter values returns error
    User update request with a user with "admin" role and incorrect parameter values returns error.

  @wip
  Scenario: User with "admin" role updating the details of another user with existing email returns error
    User with "admin" role updating the details of another user with a previously existing email returns error
