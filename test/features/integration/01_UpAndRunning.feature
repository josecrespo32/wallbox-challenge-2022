Feature: 1 - INT Heartbeat
  Check the System Under Test is ready to launch the tests
  As a QA I should be able to reach and interact with the SUT prior lo launch further tests

  @f01 @integration @heartbeat
  Scenario: Endpoint is Up&Running
    Given a "GET" HTTP action against the url "http://localhost:3000" and Uri "/"
    When I send the request without headers
    Then I should receive a HTTP response "200"
    And body response should contain
      | body_value                                                   |
      | {"message": "Wallbox Challenge API REST is up and running!"} |

  @f01 @integration @heartbeat
  Scenario: Endpoint is Up&Running with invalid paths
    Given a "GET" HTTP action against the url "http://localhost:3000" and Uri "/randompath"
    When I send the request without headers
    Then I should receive a HTTP response "404"

