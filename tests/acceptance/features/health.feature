Feature: Health endpoint feature
  As a user I want to be able to check if the app is up and running

  @integration
  Scenario: Call the health endpoint and verify answer is ok
    Given the request host "http://localhost:3000"
    And the request path "/"
    And the request headers
      | header_name | header_value     |
      | accept      | application/json |
    When I make a "GET" request
    Then status code is "200"
    And the response headers are
      | header_name                 | header_value                    |
      | access-control-allow-origin | *                               |
      | content-length              | 59                              |
      | content-type                | application/json; charset=utf-8 |
      | x-powered-by                | Express                         |
    And json response body is the following
    """
    {
      "message": "Wallbox Challenge API REST is up and running!"
    }
    """