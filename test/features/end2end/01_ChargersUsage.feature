Feature: 1 - E2E Chargers User linking
  As a User of the platform and chargers I should be able to link/unlink to chargers to Users

  @f1  @user_charger @e2e
  Scenario Outline: Admin can create a User + Charger and link model <model> to it
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type user with email <email> and password <pwd>
    And I select UID from email <email>
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID and user UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And the response body field message should be Allowed user to access charger
    And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/chargers"
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "200"
    And the charger <id> should include the user <email> as linked

    Examples:
      | email                        | pwd           | model       | id         |
      | e2e_new_user_111@wallbox.com | user412034e2e | Pulsar Plus | 3331456601 |
      | e2e_new_user_222@wallbox.com | user412134e2e | Commander   | 3331456602 |
      | e2e_new_user_333@wallbox.com | user412234e2e | Quasar      | 3331456603 |


  @f1   @user_charger @e2e
  Scenario Outline: Admin can UNlink charger from user for model <model>
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type user with email <email> and password <pwd>
    And I select UID from email <email>
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID and user UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And the response body field message should be Allowed user to access charger
    When a "DELETE" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID and user UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And the response body field message should be Removed charger access from user
    And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/chargers"
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "200"
    And the charger <id> should NOT include the user <email> as linked

    Examples:
      | email                           | pwd           | model       | id     |
      | e2e_new_user123132@wallbox.com  | user412034e2e | Pulsar Plus | 545776 |
      | e2e_new_user7655743@wallbox.com | user412134e2e | Commander   | 3321   |
      | e2e_new_user94592@wallbox.com   | user412234e2e | Quasar      | 7823   |


  @f1   @user_charger @e2e @bug
    #BUG Deleting a user should remove the link from the chargers where is linked
  Scenario Outline: BUG Admin can UNlink charger by deleting a user for model <model>
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type user with email <email> and password <pwd>
    And I select UID from email <email>
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID and user UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And the response body field message should be Allowed user to access charger
    When a "DELETE" HTTP action against the url "http://localhost:3000" and Uri "/users" and UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "204"
    And a "GET" HTTP action against the url "http://localhost:3000" and Uri "/chargers"
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    And I should receive a HTTP response "200"
    And the charger <id> should NOT include the user <email> as linked

    Examples:
      | email                 | pwd           | model       | id      |
      | del122335@wallbox.com | user412034e2e | Pulsar Plus | 8844134 |
      | del123455@wallbox.com | user412134e2e | Commander   | 8841244 |
      | del123845@wallbox.com | user412234e2e | Quasar      | 8879335 |


  @f1   @user_charger @e2e
  Scenario Outline: User cannot link a charger model <model>
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type user with email <email> and password <pwd>
    And I select UID from email <email>
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    Given a user with email <email> and password <pwd> requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID and user UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "401"
    And the response body field message should be Insufficient permissions

    Examples:
      | email              | pwd           | model       | id      |
      | 55521@wallbox.com  | user412034e2e | Pulsar Plus | 555213  |
      | 555214@wallbox.com | user412134e2e | Commander   | 555214  |
      | 555215@wallbox.com | user412234e2e | Quasar      | 5552145 |


  @f1   @user_charger @e2e @bug
    #BUG User can NOT be unlinked as User from charger where is registered
  Scenario Outline: BUG User can UNlink a charger model <model> that is owned by himself
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new user type user with email <email> and password <pwd>
    And I select UID from email <email>
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID and user UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And the response body field message should be Allowed user to access charger
    Given a user with email <email> and password <pwd> requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID and user UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "204"
    And the charger <id> should NOT include the user <email> as linked

    Examples:
      | email                 | pwd           | model       | id         |
      | 542552213@wallbox.com | user412034e2e | Pulsar Plus | 5554431213 |
      | 555212314@wallbox.com | user412134e2e | Commander   | 555234214  |
      | 555223415@wallbox.com | user412234e2e | Quasar      | 555211145  |