@core @core_group @role_visibility
Feature: Test role visibility
  In order to control access
  As an admin
  I need to control which roles can see each other

  Background: Set up some groups
    Given  the following "courses" exist:
      | fullname | shortname |
      | Course 1 | C1        |
    And the following "users" exist:
      | username | firstname | lastname | email                |
      | student1 | Student   | 1        | student1@example.com |
      | student2 | Student   | 2        | student2@example.com |
      | manager1 | Manager   | 1        | manager1@example.com |
    And the following "course enrolments" exist:
      | user     | course | role    |
      | student1 | C1     | student |
      | student2 | C1     | student |
      | manager1 | C1     | manager |
    And the following "groups" exist:
      | name    | course | idnumber |
      | Group 1 | C1     | G1       |
    And the following "group members" exist:
      | user     | group |
      | student1 | G1    |
      | student2 | G1    |

  @javascript
  Scenario: Check the default roles are visible
    Given I log in as "manager1"
    And I follow "Course 1"
    And I expand "Users" node
    And I follow "Groups"
    When I set the field "groups" to "Group 1 (2)"
    Then "optgroup[label='Other']" "css_element" should not exist in the "#members" "css_element"
    And "optgroup[label='Student']" "css_element" should exist in the "#members" "css_element"
    And I log out

  @javascript
  Scenario: Do not allow managers to view any roles and check they are hidden
    Given I log in as "admin"
    And I navigate to "Define roles" node in "Site administration > Users > Permissions"
    And I follow "Edit Manager role"
    And I set the following fields to these values:
      | Allow role to view |  |
    And I press "Save changes"
    And I log out
    When I log in as "manager1"
    And I follow "Course 1"
    And I expand "Users" node
    And I follow "Groups"
    And I set the field "groups" to "Group 1 (2)"
    Then "optgroup[label='Other']" "css_element" should exist in the "#members" "css_element"
    And "optgroup[label='Student']" "css_element" should not exist in the "#members" "css_element"
    And I log out