Feature: User deletion
  Test user deletion.
  Signin is required.
  Only users with "admin" role can delete users with "user" role.


  Scenario: User with "admin" role can delete users with "user" role
    Successful user deletion with a user with "admin" role.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I create the user "user_new" from configuration
      And I sign in as "admin" user
     When a "DELETE" HTTP request is sent to resource "/users/CONF:users.user_new.uid"
     Then the HTTP response status is "204"


 Scenario: User with "user" role can not delete users with "user" role
   User deletion request from a user with "user" role returns error.
   Given the app is up and ready for testing
     And I wipe the "users" database
     And I create the user "user_new" from configuration
     And I sign in as "user" user
    When a "DELETE" HTTP request is sent to resource "/users/CONF:users.user_new.uid"
    Then the HTTP response status is "401"
     And the HTTP response body contains
         | param   | value                    |
         | status  | 401                      |
         | message | Insufficient permissions |


  Scenario: User with "admin" role can not delete users with "admin" role
    User with "admin" role deletion request from a user with "admin" role returns error.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I create the user "admin_new" from configuration
      And I sign in as "admin" user
     When a "DELETE" HTTP request is sent to resource "/users/CONF:users.admin_new.uid"
     Then the HTTP response status is "403"
      And the HTTP response body contains
          | param   | value                       |
          | status  | 403                         |
          | message | Cannot access that resource |


  Scenario: User deletion missing authentication returns error
    User deletion request missing authentication returns error.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I create the user "user_new" from configuration
     When a "DELETE" HTTP request is sent to resource "/users/CONF:users.user_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |
