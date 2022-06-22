Feature: 4 - INT Chargers management
  As a User of the platform and chargers I should be able to CRUD chargers

  @f04 @chargers @integration
  Scenario: List registered chargers
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/chargers"
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And I should receive a list of the chargers

  @f04 @chargers @integration @BUG
       #chargers.js shows models   body('model').notEmpty().isString().isIn(['Pulsar Plus', 'Commander', 'Quasar']),
       #BUB Models not documented in SWAGGER
      #BUG Serial type not documented in swagger
    #BUG Expeted 201 instead of 200 for charger ADD
  Scenario Outline: Add a new charger
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers/"
    And prepare body with data
      | body_param_name | body_param_value |
      | serialNumber    | <id>             |
      | model           | <model>          |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response should include fields "message charger"
    And I store the charger UID from response

    Examples:
      | model       | id           |
      | Pulsar Plus | 111122221111 |
      | Commander   | 22223334444  |
      | Quasar      | 4444555666   |


@f04 @chargers @integration
  Scenario Outline: Add a new charger already added
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers/"
    And prepare body with data
      | body_param_name | body_param_value |
      | serialNumber    | <id>             |
      | model           | <model>          |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response should include fields "message charger"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/chargers/"
    And prepare body with data
      | body_param_name | body_param_value |
      | serialNumber    | <id>             |
      | model           | <model>          |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "409"
    And the response body field message should be Serial number already in use

    Examples:
      | model       | id             |
      | Pulsar Plus | 11112010221111 |


  @f04 @chargers @integration
  Scenario Outline: DELETE a charger MODEL <model>
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "DELETE" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "204"

    Examples:
      | model       | id          |
      | Pulsar Plus | 10333012011 |
      | Commander   | 2333112122  |
      | Quasar      | 3333212233  |


  @f04 @chargers @integration
  Scenario Outline: Update a charger MODEL <model> and serialNumber
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "PUT" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID
    And prepare body with data
      | body_param_name | body_param_value |
      | serialNumber    | <new_id>         |
      | model           | <new_model>      |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response body field message should be Charger updated
    When a "GET" HTTP action against the url "http://localhost:3000" and Uri "/chargers"
    And I send the request with headers without body
      | header_name   | header_value     |
      | accept        | application/json |
      | Authorization | {context.token}  |
    Then I should receive a HTTP response "200"
    And I should receive a list of the chargers
    When a "DELETE" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID
    And I send the request with headers without body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "204"

    Examples:
      | model       | id         | new_model   | new_id   |
      | Pulsar Plus | 1231010231 | Commander   | 32165401 |
      | Commander   | 1231010232 | Quasar      | 32165402 |
      | Quasar      | 1231010233 | Pulsar Plus | 32165403 |

  @f04 @chargers @integration
  Scenario Outline: Update a charger Number <model>
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "PUT" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID
    And prepare body with data
      | body_param_name | body_param_value |
      | model           | <new_model>      |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response body field message should be Charger updated


    Examples:
      | model       | id       | new_model |
      | Pulsar Plus | 55510444 | Commander |

  @f04 @chargers @integration
  Scenario Outline: Update a charger SerialNumber <id> to <new_serial>
    Given a user with email admin@wallbox.com and password admin1234 requests a valid token
    And I create a new Charger type <model> and ID <id>
    And I store the charger UID from response
    When a "PUT" HTTP action against the url "http://localhost:3000" and Uri "/chargers" and charger UID
    And prepare body with data
      | body_param_name | body_param_value |
      | serialNumber    | <new_serial>     |
    And I send the request with headers with body
      | header_name   | header_value     |
      | Authorization | {context.token}  |
      | accept        | application/json |
      | Content-Type  | application/json |
    Then I should receive a HTTP response "200"
    And the response body field message should be Charger updated


    Examples:
      | model       | id       | new_serial |
      | Pulsar Plus | 55500444 | 666555     |