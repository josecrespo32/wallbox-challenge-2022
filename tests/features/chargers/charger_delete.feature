Feature: Charger deletion
  Test charger deletion.
  Signin is required.
  Only users with "admin" role can delete chargers.


  Scenario: User with "admin" role can delete a charger
    Successful charger deletion with a user with "admin" role.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
      And I sign in as "admin" user
     When a "DELETE" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid"
     Then the HTTP response status is "204"


  Scenario: User with "user" role can not delete a charger
    Charger deletion request from a user with "user" role returns error.
    BUG: "403 Forbidden" expected
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
      And I sign in as "user" user
     When a "DELETE" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                    |
          | status  | 401                      |
          | message | Insufficient permissions |

  Scenario: Charger deletion missing authentication returns error
    Charger deletion request missing authentication returns error.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
     When a "DELETE" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |
