Feature: User signin
  Test user signin request.
  Signin is required to perform most operations.


  Scenario Outline: Successful signin for user with role "<role>"
    Successful signin request for users with both "admin" and "user" roles.
    Given the app is up and ready for testing
     When a "POST" HTTP request is sent to resource "/signin" with parameters
          | param    | value                      |
          | email    | CONF:users.<role>.email    |
          | password | CONF:users.<role>.password |
     Then the HTTP response status is "200"
      And the HTTP response body contains a valid UID
      And the HTTP response body contains a valid JWT
      And the HTTP response body contains
          | param | value                   |
          | uid   | CONTEXT:uid             |
          | jwt   | CONTEXT:jwt             |
          | email | CONF:users.<role>.email |

    Examples:
      | role  |
      | user  |
      | admin |


  Scenario Outline: Failed signin request due to incorrect method returns error
    Incorrect signin request due to incorrect HTTP method used.
    BUG: "405 Method Not Allowed" expected.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
     When a "<method>" HTTP request is sent to resource "/signin" with parameters
          | param    | value                    |
          | email    | CONF:users.user.email    |
          | password | CONF:users.user.password |
     Then the HTTP response status is "404"
      And the HTTP response body contains
          | param   | value     |
          | status  | 404       |
          | message | Not Found |

    Examples: <method>
      | method  |
      | GET     |
      | PUT     |
      | DELETE  |
      | PATCH   |

  @skip
  Scenario: Failed signin request due to missing body returns error
    Incorrect signin request due to missing body.
    BUG: Malformed response. Duplicated elements.
    Given the app is up and ready for testing
     When a "POST" HTTP request is sent to resource "/signin"
     Then the HTTP response status is "400"
      And the HTTP response body contains
          | param   | value                                                                                                                     |
          | errors  | [{"msg":"Invalid value","param":"email","location":"body"}, {"msg":"Invalid value","param":"password","location":"body"}] |


  @skip
  Scenario Outline: Failed signin request due to missing parameters returns error
    Incorrect signin request due to missing parameters.
    BUG: Malformed response. Duplicated elements.
    Given the app is up and ready for testing
     When a "POST" HTTP request is sent to resource "/signin" with parameters
          | param   | value   |
          | <param> | <value> |
     Then the HTTP response status is "400"
      And the HTTP response body contains
          | param   | value           |
          | errors  | <error message> |

    Examples: <scenario_name>
      | scenario_name    | param    | value                    | error message                                                  |
      | missing email    | password | CONF:users.user.password | [{"msg":"Invalid value","param":"email","location":"body"}]    |
      | missing password | email    | CONF:users.user.email    | [{"msg":"Invalid value","param":"password","location":"body"}] |


  Scenario Outline: Failed signin request due to incorrect parameter values returns error
    Incorrect signin request due to incorrect parameter values.
    BUG: error stack was not expected in the response.
    Given the app is up and ready for testing
     When a "POST" HTTP request is sent to resource "/signin" with parameters
          | param    | value      |
          | email    | <email>    |
          | password | <password> |
     Then the HTTP response status is "401"
      And the HTTP response body contains
          | param   | value                   |
          | status  | 401                     |
          | message | Wrong email or password |

    Examples: <scenario_name>
      | scenario_name      | email                 | password              |
      | user unknown       | test@example.org      | super_secret_password |
      | incorrect password | CONF:users.user.email | incorrect             |
