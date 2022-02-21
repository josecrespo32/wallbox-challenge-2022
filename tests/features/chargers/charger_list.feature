Feature: Charger listing
  Test charger listing.
  Signin is required.


  Scenario: List chargers with user with "admin" role
    Users with "admin" role can list all chargers.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
      And I sign in as "admin" user
     When a "GET" HTTP request is sent to resource "/chargers"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param                   | value                                  |
          | chargers.0.uid          | CONF:chargers.charger_new.uid          |
          | chargers.0.serialNumber | CONF:chargers.charger_new.serialNumber |
          | chargers.0.model        | CONF:chargers.charger_new.model        |


  Scenario: List chargers with user with "user" role and no linked chargers
    Users with "user" role can not list unlinked chargers.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
      And I sign in as "user" user
     When a "GET" HTTP request is sent to resource "/chargers"
     Then the HTTP response status is "200"
      And the HTTP response body is
          '''
          {"chargers":[]}
          '''


  Scenario: List chargers request missing authentication returns error
    Charger listing request missing authentication returns error.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
     When a "GET" HTTP request is sent to resource "/chargers"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |


  Scenario: List chargers with user with "user" role and linked chargers
    Users with "user" role can only list its own linked chargers.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I wipe the "chargers" database
      And I create the user "user_new" from configuration
      And I create the charger "charger_new" from configuration
      And I link user "user_new" to charger "charger_new"
      And I sign in as "user_new" user
     When a "GET" HTTP request is sent to resource "/chargers"
     Then the HTTP response status is "200"
     And the HTTP response body contains
         | param                   | value                                  |
         | chargers.0.uid          | CONF:chargers.charger_new.uid          |
         | chargers.0.serialNumber | CONF:chargers.charger_new.serialNumber |
         | chargers.0.model        | CONF:chargers.charger_new.model        |
