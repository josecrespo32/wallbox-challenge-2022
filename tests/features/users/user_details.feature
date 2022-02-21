Feature: User details
  Test user details retrieval.
  Signin is required.
  Users with "admin" role can retrieve details from every other user.
  Users with "user" role can only get its own details.


  Scenario Outline: User with role "<role>" gets its own details
    Every user role can retrieve its own details.
    Given the app is up and ready for testing
      And I sign in as "<role>" user
     When a "GET" HTTP request is sent to resource "/users/CONTEXT:uid"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param | value                   |
          | uid   | CONTEXT:uid             |
          | email | CONF:users.<role>.email |
          | role  | CONF:users.<role>.role  |

    Examples:
      | role  |
      | user  |
      | admin |


  Scenario: User with "admin" role can get other user's details
    Users with "admin" role can retrieve details of every other user.
    Given the app is up and ready for testing
      And I enrich the users list
      And I sign in as "admin" user
     When a "GET" HTTP request is sent to resource "/users/CONF:users.user.uid"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param | value                 |
          | uid   | CONF:users.user.uid   |
          | email | CONF:users.user.email |
          | role  | CONF:users.user.role  |


  Scenario: Get the user details missing authentication returns error
    User details request missing authentication returns error.
    Given the app is up and ready for testing
      And I enrich the users list
     When a "GET" HTTP request is sent to resource "/users/CONF:users.user.uid"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                  |
          | status  | 401                    |
          | message | Could not verify token |


  Scenario: User with "user" role can not get other user's details
    Users with "user" role can not retrieve details of any other user.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
      And I enrich the users list
      And I sign in as "user" user
     When a "GET" HTTP request is sent to resource "/users/CONF:users.admin.uid"
     Then the HTTP response status is "403"
      And the HTTP response body contains
          | param   | value                       |
          | status  | 403                         |
          | message | Cannot access that resource |
