Feature: Link deletion
  Test link deletion between any user and any charger.
  Signin is required.
  Only users with "admin" role can delete links.


  Scenario: Delete a link with a user with "admin" role
    Successful link deletion with a user with "admin" role.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I wipe the "chargers" database
      And I create the user "user_new" from configuration
      And I create the charger "charger_new" from configuration
      And I link user "user_new" to charger "charger_new"
      And I sign in as "admin" user
     When a "DELETE" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid/users/CONF:users.user_new.uid"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param                | value                                  |
          | message              | Removed charger access from user       |
          | charger.uid          | CONF:chargers.charger_new.uid          |
          | charger.serialNumber | CONF:chargers.charger_new.serialNumber |
          | charger.model        | CONF:chargers.charger_new.model        |


  Scenario: Delete a link with a user with "user" role returns error
    Link deletion request with a user with "user" role returns error.
    BUG: "403 Forbidden" expected
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I wipe the "chargers" database
      And I create the user "user_new" from configuration
      And I create the charger "charger_new" from configuration
      And I link user "user_new" to charger "charger_new"
      And I sign in as "user" user
     When a "DELETE" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid/users/CONF:users.user_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                    |
          | status  | 401                      |
          | message | Insufficient permissions |


  Scenario: Delete a link missing authentication returns error
    Link deletion request missing authentication returns error.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I wipe the "chargers" database
      And I create the user "user_new" from configuration
      And I create the charger "charger_new" from configuration
      And I link user "user_new" to charger "charger_new"
     When a "DELETE" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid/users/CONF:users.user_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |
