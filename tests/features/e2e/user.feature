# -*- coding: utf-8 -*-


Feature: USER ROLE
  As an user with user role
  I want to test each of the actions it can perform
  and those actions it can not
  checking their impact on the data stored



  Scenario Outline: USER ROLE - User with user role can not create a new user
    Given the app is up and running
    And   the user "user@wallbox.com" gets a new valid token using password "user1234"
    When  the admin requests the creation of the user "[RANDOM]@example.com" with password "newuser1234" and "<role>" role
    Then  the new user can not log in using password "newuser1234"
    Examples: <role>
    | role  |
    | user  |
    | admin |


  Scenario Outline: USER ROLE - User with user role can not create a new charger
    Given the app is up and running
    And   the user "user@wallbox.com" gets a new valid token using password "user1234"
    When  the user requests the creation of the "<model>" charger with serial number "[RANDOM_INT]"
    Then  the charger serial number of the creation attempt can not be found by the admin "admin@wallbox.com"
    Examples: <model>
    | model       |
    | Pulsar Plus |
    | Commander   |
    | Quasar      |


  Scenario Outline: USER ROLE - User with user role can not access to the info of any other user whatever the role it has
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    When  the admin requests the creation of the user "[RANDOM]@example.com" with password "newuser1234" and "<role>" role
    Then  the user "user@wallbox.com" can not check the just created user info
    Examples: <role>
    | role  |
    | user  |
    | admin |

  @test
  Scenario Outline: USER ROLE - User with user role can not access to the info of chargers not assigned to it
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    When  the admin requests the creation of the "<model>" charger with serial number "[RANDOM_INT]"
    Then  the user "user@wallbox.com" can not see the info of the just created charger
    Examples: <model>
    | model       |
    | Pulsar Plus |
    | Commander   |
    | Quasar      |


  Scenario Outline: USER ROLE - User with user role can not assign chargers to any user whatever the role it has
    Given the app is up and running
    And   the user "admin@wallbox.com" gets a new valid token using password "admin1234"
    And   the admin requests the creation of the "<model>" charger with serial number "[RANDOM_INT]"
    And   the admin requests the creation of the user "[RANDOM]@example.com" with password "newuser1234" and "<role>" role
    And   the user "user@wallbox.com" gets a new valid token using password "user1234"
    When  the user requests the assignation of the just created charger to the just created user
    Then  the just created user can not see the info of the just created charger
    Examples: <model> to <role>
    | model       | role  |
    | Pulsar Plus | user  |
    | Commander   | user  |
    | Quasar      | user  |
    @BUG_003
    Examples: <model> to <role>
    | model       | role  |
    | Pulsar Plus | admin |
    | Commander   | admin |
    | Quasar      | admin |
