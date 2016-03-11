@core @core_enrol @role_visibility
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
      | learner2 | Learner   | 2        | learner2@example.com |
      | manager1 | Manager   | 1        | manager1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role    |
      | learner1 | C1     | student |
      | learner2 | C1     | student |
      | manager1 | C1     | manager |

  Scenario: Check the default roles are visible
    Given I log in as "manager1"
    When I follow "Course 1"
    And I navigate to "Enrolled users" node in "Course administration > Users"
    Then the "Role" select box should contain "Student"
    And the "Role" select box should contain "Manager"
    And I should see "Student" in the "table.userenrolment" "css_element"
    And I should see "Manager" in the "table.userenrolment" "css_element"
    And I should not see "Other" in the "table.userenrolment" "css_element"

  Scenario: Do not allow managers to view any roles but manager and check they are hidden
    Given I log in as "admin"
    And I navigate to "Define roles" node in "Site administration > Users > Permissions"
    And I follow "Edit Manager role"
    And I set the following fields to these values:
      | Allow role to view | Manager |
    And I press "Save changes"
    And I log out
    When I log in as "manager1"
    And I follow "Course 1"
    And I navigate to "Enrolled users" node in "Course administration > Users"
    Then the "Role" select box should not contain "Student"
    And the "Role" select box should contain "Manager"
    And I should not see "Student" in the "table.userenrolment" "css_element"
    And I should see "Manager" in the "table.userenrolment" "css_element"
    And I should see "Other" in the "table.userenrolment" "css_element"