@core @core_enrol @role_visibility @role_visibility_main
Feature: Test role visibility
  In order to control access
  As an admin
  I need to control which roles can see each other

  Background: Add a bunch of users
    Given  the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | learner1 | Learner   | 1        | learner1@example.com |
      | learner3 | Learner   | 3        | learner3@example.com |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | teacher2 | Teacher   | 2        | teacher2@example.com |
      | manager1 | Manager   | 1        | manager1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | learner1 | C1     | student        |
      | teacher1 | C1     | editingteacher |
      | teacher2 | C1     | editingteacher |
      | manager1 | C1     | manager        |


  Scenario: Check the default roles are visible
    Given I log in as "manager1"
    When I follow "Course 1"
    And I navigate to "Enrolled users" node in "Course administration > Users"
    And "Learner 1" row "Roles" column of "participants" table should contain "Student"
    And "Teacher 1" row "Roles" column of "participants" table should contain "Teacher"
    And "Manager 1" row "Roles" column of "participants" table should contain "Manager"
    And I should not see "No Roles" in the "table#participants" "css_element"

  Scenario: Do not allow managers to view any roles but manager and check they are hidden (origin)
    When I log in as "teacher1"
    And I am on "Course 1" course homepage
    And I navigate to "Enrolled users" node in "Course administration > Users"
    And "Learner 1" row "Roles" column of "participants" table should contain "Student"
    And "Teacher 1" row "Roles" column of "participants" table should contain "Teacher"
    And "Manager 1" row "Roles" column of "participants" table should not contain "Manager"
    And "Manager 1" row "Roles" column of "participants" table should contain "No roles"


  Scenario: Do not allow teachers to view only role students and check other roles are hidden
    Given I log in as "admin"
    And I am on site homepage
    And I navigate to "Users > Permissions > Define roles" in site administration
    And I follow "Edit Teacher role"
    And I set the following fields to these values:
      | Allow role to view | Student |
    And I press "Save changes"
    And I log out
    When I log in as "teacher1"
    And I am on site homepage
    And I follow "Course 1"
    And the following "course enrolments" exist:
      | user     | course | role    |
      | teacher2 | C1     | student |
    And I navigate to "Enrolled users" node in "Course administration > Users"
    Then the "Filter" select box should not contain "Role: Manager"
    And the "Filter" select box should contain "Role: Student"
    And "Learner 1" row "Roles" column of "participants" table should contain "Student"
    And "Teacher 1" row "Roles" column of "participants" table should not contain "Teacher"
    And "Teacher 1" row "Roles" column of "participants" table should contain "No roles"
    And "Teacher 2" row "Roles" column of "participants" table should not contain "Teacher"
    And "Teacher 2" row "Roles" column of "participants" table should contain "Student"
    And "Manager 1" row "Roles" column of "participants" table should not contain "Manager"
    And "Manager 1" row "Roles" column of "participants" table should contain "No roles"


  Scenario: Create role without any capabilities, but visible to managers and check that role is visible
    Given I log in as "admin"
    And I am on site homepage
    And I navigate to "Users > Permissions > Define roles" in site administration
    And I press "Add a new role"
    And I press "Continue"
    And I set the following fields to these values:
      | Short name | newrole |
      | Custom full name | NewRoleFullName |
      | Course | Yes |
      | Allow role to view | Manager, Teacher |
    And I press "Create this role"
    And I am on site homepage
    And I navigate to "Users > Permissions > Define roles" in site administration
    And I follow "Edit Manager role"
    And I set the following fields to these values:
      | Allow role to view | Manager, NewRoleFullName |
    And I press "Save changes"
    And the following "course enrolments" exist:
      | user     | course | role    |
      | learner3 | C1     | newrole |
    And I log out
    When I log in as "manager1"
    And I am on site homepage
    And I follow "Course 1"
    And I navigate to "Enrolled users" node in "Course administration > Users"
    And "Learner 3" row "Roles" column of "participants" table should contain "NewRoleFullName"
    And I log out
    When I log in as "teacher1"
    And I am on site homepage
    And I follow "Course 1"
    And I navigate to "Enrolled users" node in "Course administration > Users"
    And "Learner 3" row "Roles" column of "participants" table should not contain "NewRoleFullName"
    And I log out
    Given I log in as "admin"
    And I am on site homepage
    And I navigate to "Users > Permissions > Define roles" in site administration
    And I follow "Edit Teacher role"
    And I set the following fields to these values:
      | Allow role to view | Manager, Teacher, NewRoleFullName |
    And I press "Save changes"
    And I log out
    When I log in as "teacher1"
    And I am on site homepage
    And I follow "Course 1"
    And I navigate to "Enrolled users" node in "Course administration > Users"
    And "Learner 3" row "Roles" column of "participants" table should contain "NewRoleFullName"
    And I log out
