Feature: Charger creation
  Test charger creation.
  Signin is required.
  Only users with "admin" role can create new chargers.


  Scenario: Create a new charger with a user with "admin" role
    Successful charger creation with a user with "admin" role.
    BUG: "201 Created" expected.
    BUG: Definition in Swagger is incomplete. Only certain models allowed.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I sign in as "admin" user
     When a "POST" HTTP request is sent to resource "/chargers" with parameters
          | param        | value                                  |
          | serialNumber | CONF:chargers.charger_new.serialNumber |
          | model        | CONF:chargers.charger_new.model        |
      Then the HTTP response status is "200"
      And the HTTP response body contains
          | param                | value                                  |
          | message              | Charger registered                     |
          | charger.serialNumber | CONF:chargers.charger_new.serialNumber |
          | charger.model        | CONF:chargers.charger_new.model        |


  Scenario: Create a new charger with a user with "user" role returns error
    Charger creation request with a user with "user" role returns error.
    BUG: "403 Forbidden" expected
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
      And I sign in as "user" user
     When a "POST" HTTP request is sent to resource "/chargers" with parameters
          | param        | value                                  |
          | serialNumber | CONF:chargers.charger_new.serialNumber |
          | model        | CONF:chargers.charger_new.model        |
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                    |
          | status  | 401                      |
          | message | Insufficient permissions |



  Scenario: Create a new charger missing authentication returns error
    Charger creation request missing authentication returns error.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "chargers" database
     When a "POST" HTTP request is sent to resource "/chargers" with parameters
          | param        | value                                  |
          | serialNumber | CONF:chargers.charger_new.serialNumber |
          | model        | CONF:chargers.charger_new.model        |
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |


  @wip
  Scenario: Create a new charger with a user with "admin" role with missing body returns error
    Charger creation request with a user with "admin" role and missing body returns error.

  @wip
  Scenario: Create a new charger with a user with "admin" role with missing parameters returns error
    Charger creation request with a user with "admin" role and missing parameters returns error.

  @wip
  Scenario: Create a new charger with a user with "admin" role with incorrect parameter values returns error
    Charger creation request with a user with "admin" role and incorrect parameter values returns error.

  @wip
  Scenario: Create a new charger with a user with "admin" role with existing serialNumber returns error
    Charger creation request with a user with "admin" role to an already existing serialNumber returns error.

  @wip
  Scenario: Create a new charger with a user with "admin" role with incorrect model returns error
    Charger creation request with a user with "admin" role to an incorrect model returns error.
