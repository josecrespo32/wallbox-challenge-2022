# Created by xvc at 16/6/22
Feature: 3 - INT Users management and details
  As a platform admin should be able to create/delete and update users

  @f03 @user @integration
  Scenario: Admin request a Token and user info
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users"
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And I should receive a list of the users
    And the list of users should be 2 at least

  @f03 @user @integration
  Scenario: Admin request /user a about himself
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I request data from all users
    And I select UID from email admin@wallbox.com
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And the response should include fields "uid email role"


  @f03 @user @integration
  Scenario: Admin request /user a about USER
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I request data from all users
    And I select UID from email user@wallbox.com
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And the response should include fields "uid email role"

  @f03 @user @integration
  Scenario: UNAuthorized Admin Token can NOT Request own USER info
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I request data from all users
    And I select UID from email user@wallbox.com
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | faketoken        |
    Then I should receive a HTTP response "401"


  @f03 @user @integration
  Scenario: Authorized User Token can NOT Request other USER info
    Given a user with email user@wallbox.com and password user1234 requests a valid token
    When I request data from all users
    Then User only retrieve his own data


  @f03 @user @integration @bug @Invalid_value_emailConfirmation_passwordConfirmation
    #BUG the doc is not updated with API ADD request parameters
  Scenario: BUG Admin can ADD a new /user
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/users/"
    And prepare body with data
      | body_param_name      | body_param_value      |
      | email                | new_user5@wallbox.com |
      | password             | user21234             |
      | role                 | user                  |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response should include fields "message user"

  @f03 @user @integration @bug
    #BUG the doc is not updated with API ADD request parameters
  Scenario:  Admin can ADD a new /user
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/users/"
    And prepare body with data
      | body_param_name      | body_param_value      |
      | email                | new_user5@wallbox.com |
      | emailConfirmation    | new_user5@wallbox.com |
      | password             | user21234             |
      | passwordConfirmation | user21234             |
      | role                 | user                  |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response should include fields "message user"


  @f03 @user @integration @bug @not_in_doc
#    "status":409,"message":"Email already in use","stack":"ConflictError: Email already in use
    # Expected Error 400 or documented 409 error
  Scenario: BUG Admin can ADD a new /user Repeated Email
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/users/"
    And prepare body with data
      | body_param_name      | body_param_value      |
      | email                | new_user5@wallbox.com |
      | emailConfirmation    | new_user5@wallbox.com |
      | password             | user21234             |
      | passwordConfirmation | user21234             |
      | role                 | user                  |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "400"
    And the response should include fields "status message stack"

  @f03 @user @integration
    # Assuming the code is more updated than the docs we use the requested params to continue the tests
  Scenario: Admin can ADD a new /admin
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/users/"
    And prepare body with data
      | body_param_name      | body_param_value       |
      | email                | new_admin5@wallbox.com |
      | emailConfirmation    | new_admin5@wallbox.com |
      | password             | admin21234             |
      | passwordConfirmation | admin21234             |
      | role                 | admin                  |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response should include fields "message user"


  @f03 @user @integration
  Scenario: User can NOT ADD a new /admin
    Given a user with email user@wallbox.com and password user1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/users/"
    And prepare body with data
      | body_param_name      | body_param_value       |
      | email                | new_admin6@wallbox.com |
      | emailConfirmation    | new_admin6@wallbox.com |
      | password             | admin21234             |
      | passwordConfirmation | admin21234             |
      | role                 | admin                  |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "401"
    And the response should include fields "status message stack"
    And the response body field message should be Insufficient permissions

  @f03 @user @integration
  Scenario: User can NOT ADD a new /user
    Given a user with email user@wallbox.com and password user1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/users/"
    And prepare body with data
      | body_param_name      | body_param_value      |
      | email                | new_user8@wallbox.com |
      | emailConfirmation    | new_user8@wallbox.com |
      | password             | user21234             |
      | passwordConfirmation | user21234             |
      | role                 | user                  |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "401"
    And the response should include fields "status message stack"
    And the response body field message should be Insufficient permissions


  @f03 @user @integration
  Scenario: Admin can ADD an ADMIN user but cannot Request data from that Admin user
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type admin with email new_admindel4@wallbox.com and password admindel21234
    And I select UID from email new_admindel4@wallbox.com
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "403"
    And the response body field message should be Cannot access that resource


  @f03 @user @integration @deleted_user
  Scenario: Admin can ADD an USER user and DELETE it
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type user with email new_user43@wallbox.com and password user41234
    And I select UID from email new_user43@wallbox.com
    And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "200"
    When a "DELETE" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "204"
    And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "404"
    And the response body field message should be User not found


  @f03 @user @integration @deleted_user
  Scenario: Admin can ADD an ADMIN user but CANNOT DELETE it
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type admin with email new_admin51@wallbox.com and password admin31234
    And I select UID from email new_admin51@wallbox.com
    When a "DELETE" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "403"
    And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "403"
    And the response body field message should be Cannot access that resource

  @f03 @user @integration @deleted_user
  Scenario: Admin can ADD an ADMIN user and new_admin can DELETE itself
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type admin with email new_admin53@wallbox.com and password admin31234
    And I select UID from email new_admin53@wallbox.com
    Given a user with email new_admin53@wallbox.com and password admin31234 requests a valid token
    When a "DELETE" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "204"
    And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "404"
    And the response body field message should be User not found

  @f03 @user @integration @update_user
  Scenario: Admin can NOT UPDATE another ADMIN user
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type admin with email new_admin56@wallbox.com and password admin31234
    And I select UID from email new_admin56@wallbox.com
    When a "PUT" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And prepare body with data
      | body_param_name      | body_param_value        |
      | email                | new_admin56@wallbox.com |
      | emailConfirmation    | new_admin56@wallbox.com |
      | password             | user21234Newpass        |
      | passwordConfirmation | user21234Newpass        |
      | role                 | user                    |
    And I send the request with headers with body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "403"
    And the response body field message should be Cannot access that resource

 @user @update_user
  Scenario: Admin can UPDATE itself data
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type admin with email new_admin60@wallbox.com and password admin31234
    And I select UID from email new_admin60@wallbox.com
   Given a user with email new_admin60@wallbox.com and password admin31234 requests a valid token
    When a "PUT" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And prepare body with data
      | body_param_name      | body_param_value        |
      | email                | new_admin60@wallbox.com |
      | emailConfirmation    | new_admin60@wallbox.com |
      | password             | user21234Newpass        |
      | passwordConfirmation | user21234Newpass        |
      | role                 | user                    |
    And I send the request with headers with body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"


@user @update_user
  Scenario: Admin can UPDATE USER data
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type user with email new_user60@wallbox.com and password admin31234
    And I select UID from email new_user60@wallbox.com
    When a "PUT" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And prepare body with data
      | body_param_name      | body_param_value        |
      | email                | new_user60@wallbox.com |
      | emailConfirmation    | new_user60@wallbox.com |
      | password             | user21234Newpass        |
      | passwordConfirmation | user21234Newpass        |
      | role                 | user                    |
    And I send the request with headers with body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
  And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"

