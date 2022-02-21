Feature: Charger details
  Test charger details retrieval.
  Signin is required.
  Only users with "admin" role can retrieve details from any charger.


  Scenario: User with "admin" role can get any charger's details
    Users with "admin" role can retrieve details of every charger.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
      And I sign in as "admin" user
     When a "GET" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param        | value                                  |
          | uid          | CONF:chargers.charger_new.uid          |
          | serialNumber | CONF:chargers.charger_new.serialNumber |
          | model        | CONF:chargers.charger_new.model        |


  Scenario: User with "user" role can not get any charger's details
    Users with "user" role can not retrieve the details of unlinked charger.
    BUG: "403 Forbidden" expected
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
      And I sign in as "user" user
     When a "GET" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid"
     Then the HTTP response status is "403"
      And the HTTP response body contains
          | param   | value                       |
          | status  | 403                         |
          | message | Cannot access that resource |


  Scenario: Get a charger details missing authentication returns error
    Charger details request missing authentication returns error.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I create the charger "charger_new" from configuration
     When a "GET" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |
