Feature: User listing
  Test user listing.
  Signin is required.
  Users with "admin" role can list users.
  Users with "user" role can only list themselves.


  Scenario: List the users with "user" role
    Users listing request with a user with "user" role only retrieves itself.
    BUG: user password is included in clear text in the response.
    Given the app is up and ready for testing
      And I sign in as "user" user
     When a "GET" HTTP request is sent to resource "/users"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param         | value                 |
          | users.0.uid   | CONTEXT:uid           |
          | users.0.email | CONF:users.user.email |
          | users.0.role  | CONF:users.user.role  |


  Scenario: List the users with "admin" role
    Users listing request with a user with "admin" role returns all users.
    Given the app is up and ready for testing
      And I wipe the "users" database
      And I sign in as "admin" user
     When a "GET" HTTP request is sent to resource "/users"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param         | value                  |
          | users.0.uid   | CONTEXT:uid            |
          | users.0.email | CONF:users.admin.email |
          | users.0.role  | CONF:users.admin.role  |
          | users.1.email | CONF:users.user.email  |
          | users.1.role  | CONF:users.user.role   |


  Scenario: List the users missing authentication returns error
    Users listing request missing authentication returns error.
    Given the app is up and ready for testing
     When a "GET" HTTP request is sent to resource "/users"
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value         |
          | status  | 401           |
          | message | Invalid token |


  Scenario Outline: List the users with role "<role>" with incorrect HTTP method returns error
    Incorrect users listing request due to incorrect HTTP method.
    BUG: error stack was not expected in the response.
    BUG: "405 Method Not Allowed" expected.
    Given the app is up and ready for testing
      And I sign in as "<role>" user
     When a "<method>" HTTP request is sent to resource "/users"
     Then the HTTP response status is "404"
      And the HTTP response body contains
          | param   | value     |
          | status  | 404       |
          | message | Not Found |

    Examples: <method>
      | role  | method |
      | user  | PUT    |
      | user  | DELETE |
      | user  | PATCH  |
      | admin | PUT    |
      | admin | DELETE |
      | admin | PATCH  |
