Feature: Link creation
  Test link creation between any user and any charger.
  Signin is required.
  Only users with "admin" role can create links.


  Scenario: Create a new link with a user with "admin" role
    Successful link creation with a user with "admin" role.
    BUG: user password is included in clear text in the response.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I wipe the "chargers" database
      And I create the user "user_new" from configuration
      And I create the charger "charger_new" from configuration
      And I sign in as "admin" user
     When a "POST" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid/users/CONF:users.user_new.uid"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param                 | value                                  |
          | message               | Allowed user to access charger         |
          | charger.uid           | CONF:chargers.charger_new.uid          |
          | charger.serialNumber  | CONF:chargers.charger_new.serialNumber |
          | charger.model         | CONF:chargers.charger_new.model        |
          | charger.users.0.uid   | CONF:users.user_new.uid                |
          | charger.users.0.email | CONF:users.user_new.email              |
          | charger.users.0.role  | CONF:users.user_new.role               |


  Scenario: Create a new link with a user with "user" role returns error
    Link creation request with a user with "user" role returns error.
    BUG: "403 Forbidden" expected
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I wipe the "chargers" database
      And I create the user "user_new" from configuration
      And I create the charger "charger_new" from configuration
      And I sign in as "user" user
     When a "POST" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid/users/CONF:users.user_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                    |
          | status  | 401                      |
          | message | Insufficient permissions |


  Scenario: Create a new link missing authentication returns error
    Link creation request missing authentication returns error.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I wipe the "chargers" database
      And I create the user "user_new" from configuration
      And I create the charger "charger_new" from configuration
     When a "POST" HTTP request is sent to resource "/chargers/CONF:chargers.charger_new.uid/users/CONF:users.user_new.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |
