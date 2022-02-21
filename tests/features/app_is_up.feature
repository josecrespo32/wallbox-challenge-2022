Feature: Challenge app is up and running
  Test the Challenge app API endpoint is ready for testing.


  Scenario: Check API Rest health
    Connect to the App listening endpoint and check the received response.
    Given the app endpoint is the configured one
     When a "GET" HTTP request is sent to resource "/"
     Then the HTTP response status is "200"
      And the HTTP response body contains
          | param   | value                                         |
          | message | Wallbox Challenge API REST is up and running! |
