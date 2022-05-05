# -*- coding: utf-8 -*-


Feature: ADMIN ROLE
  As an admin
  I want to test each of the actions it can perform
  and those actions it can not
  checking their impact on the data stored


  Scenario Outline: ADMIN ROLE - Admin creates a new user and this user can check its own data
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    When  the admin requests the creation of the user "[RANDOM]@example.com" with password "newuser1234" and "<role>" role
    Then  the new user can get a new valid token using password "newuser1234"
    And   the new user info retrieved by itself is the same as those requested in its creation
    Examples: <role>
    | role  |
    | user  |
    | admin |


  Scenario Outline: ADMIN ROLE - Admin creates a new charger and can access to its info
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    When  the admin requests the creation of the "<model>" charger with serial number "[RANDOM_INT]"
    Then  the charger data stored in the application is the same as the requested in its creation
    Examples: <model>
    | model       |
    | Pulsar Plus |
    | Commander   |
    | Quasar      |


  Scenario: ADMIN ROLE - Admin can access to the info of some other user with user role
    Given the app is up and running
    When  the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    Then  the admin can check the user "user@wallbox.com" info

  @BUG_002
  Scenario: ADMIN ROLE - Admin can not access to the info of some other admin
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    When  the admin requests the creation of the user "[RANDOM]@example.com" with password "newuser1234" and "admin" role
    Then  the admin can not check the just created user info


  Scenario Outline: ADMIN ROLE - Admin can assign any charger to any user with any role
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    And   the admin requests the creation of the "<model>" charger with serial number "[RANDOM_INT]"
    And   the admin requests the creation of the user "[RANDOM]@example.com" with password "newuser1234" and "<role>" role
    When  the admin requests the assignation of the just created charger to the just created user
    Then  the just created user can see the info of the just created charger
    Examples: <model> to <role>
    | model       | role  |
    | Pulsar Plus | user  |
    | Commander   | user  |
    | Quasar      | user  |
    | Pulsar Plus | admin |
    | Commander   | admin |
    | Quasar      | admin |


  Scenario: ADMIN ROLE - Admin can assign more than one charger to the same user
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    And   the admin requests the creation of the "Commander" charger with serial number "[RANDOM_INT]"
    And   the admin requests the creation of the "Pulsar Plus" charger with serial number "[RANDOM_INT]"
    When  the admin requests the assignation of the just created chargers to the user "user@wallbox.com"
    Then  the user "user@wallbox.com" can see the info of the just created charger


  Scenario: ADMIN ROLE - Admin can assign more than one user to the same charger
    Given the app is up and running
    And   the admin "admin@wallbox.com" gets a new valid token using password "admin1234"
    And   the admin requests the creation of the "Commander" charger with serial number "[RANDOM_INT]"
    And   the admin requests the creation of the user "[RANDOM]@example.com" with password "newuser1234" and "user" role
    When  the admin requests the assignation of the just created charger to the just created user
    And   the admin requests the assignation of the just created charger to the user "user@wallbox.com"
    Then  the just created user can see the info of the just created charger
    And   the user "user@wallbox.com" can see the info of the just created charger
