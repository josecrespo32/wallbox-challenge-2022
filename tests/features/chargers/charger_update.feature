Feature: Charger update
  Test charger details update.
  Signin is required.
  Only users with "admin" role can update details from any charger.


  Scenario: User with "admin" role update a charger details
    Users with "admin" role can update the details of every charger.
    BUG: PUT is acting as PATCH.
    Given the app is up and ready for testing
      And I create the charger "charger_new" from configuration
      And I sign in as "admin" user
     When a "PUT" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid" with parameters
          | param        | value     |
          | serialNumber | 12345     |
          | model        | Commander |
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param                | value                         |
          | message              | Charger updated               |
          | charger.uid          | CONF:chargers.charger_new.uid |
          | charger.serialNumber | 12345                         |
          | charger.model        | Commander                     |


  Scenario: User with "user" role can not update an unlinked charger details
    Users with "user" role can not update an unlinked charger details.
    BUG: "403 Forbidden" expected
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I create the charger "charger_new" from configuration
      And I sign in as "user" user
     When a "PUT" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid" with parameters
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                    |
          | status  | 401                      |
          | message | Insufficient permissions |


  Scenario: Update charger details request missing authentication returns error
    Charger update details request missing authentication returns error.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I create the charger "charger_new" from configuration
     When a "PUT" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid" with parameters
          | param        | value     |
          | serialNumber | 12345     |
          | model        | Commander |
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |


  @wip
  Scenario: User with "admin" role updating charger details with missing body returns error
    Charger update request with a user with "admin" role and missing body returns error.

  @wip
  Scenario: User with "admin" role updating charger details with missing parameters returns error
    Charger update request with a user with "admin" role and missing parameters returns error.

  @wip
  Scenario: User with "admin" role updating charger details with incorrect parameter values returns error
    Charger update request with a user with "admin" role and incorrect parameter values returns error.

  @wip
  Scenario: User with "admin" role updating charger details with incorrect parameter values returns error
    Charger update request with a user with "admin" role and incorrect parameter values returns error.

  @wip
  Scenario: User with "admin" role updating charger details with existing serialNumber returns error
    Charger update request with a user with "admin" role and existing serialNumber returns error.

  @wip
  Scenario: User with "admin" role updating charger details with non existing model returns error
    Charger update request with a user with "admin" role with non existing model returns error.
    Valid models are: Commander, Pulsar Plus and Quasar.
