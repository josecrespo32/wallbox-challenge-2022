# Created by xvc at 14/6/22
Feature: 2 - INT Authentication for users
  Valid Users should be able to retrieve token to use the API
  As a user of the platform I should retrive a API
  Not valid users should not be allowed to retrieve tokens

  @f02 @token @integration
  Scenario: Valid Token request with role USER
    Given a User with email "user@wallbox.com" and password "user1234"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "200"
    And the response should include "uid, email and jwt"

  @f02 @token @integration
  Scenario: Invalid Token request with role USER with Wrong email
    Given a User with email "randomuser@wallbox.com" and password "user1234"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"

  @f02 @token @integration
  Scenario: Invalid Token request with role USER with Wrong password
    Given a User with email "user@wallbox.com" and password "user1234wrong"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"


  @f02 @token @integration
  Scenario: Invalid Token request with role USER with Wrong email and Wrong Password
    Given a User with email "randomuser@wallbox.com" and password "user1234Wrong"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"

  @f02 @token @integration
  Scenario: Valid Token request with role ADMIN
    Given a User with email "admin@wallbox.com" and password "admin1234"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "200"
    And the response should include "uid, email and jwt"

  @f02 @token @integration
  Scenario: Invalid Token request with role ADMIN with Wrong email
    Given a User with email "randomuser@wallbox.com" and password "admin1234"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"

  @f02 @token @integration
  Scenario: Invalid Token request with role ADMIN with Wrong password
    Given a User with email "admin@wallbox.com" and password "admin1234wrong"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"


  @f02 @token @integration
  Scenario: Invalid Token request with role ADMIN with Wrong email and Wrong Password
    Given a User with email "randomuser@wallbox.com" and password "admin1234Wrong"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"


  @f02 @token @integration
  Scenario: Invalid Crossed Token request with role USER with Valid email and ADMIN Password
    Given a User with email "user@wallbox.com" and password "admin1234"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"

  @f02 @token @integration
  Scenario:  Invalid Crossed Token request with role ADMIN with Valid email and USER Password
    Given a User with email "admin@wallbox.com" and password "user1234"
    When a "POST" HTTP action against the url "http://localhost:3000" and Uri "/signin"
    And I send the request with headers with body
      | header_name  | header_value     |
      | accept       | application/json |
      | Content-Type | application/json |
    Then I should receive a HTTP response "401"

