@core @core_badges @role_visibility
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
    And I navigate to "Add a new badge" node in "Course administration > Badges"
    And I set the following fields to these values:
      | Name          | Test Badge             |
      | Description   | Test badge description |
      | issuername    | Test Badge Site        |
      | issuercontact | testuser@example.com   |
    And I upload "badges/tests/behat/badge.png" file to "Image" filemanager
    When I press "Create badge"
    And I set the following fields to these values:
      | Add badge criteria | Manual issue by role |
    Then I should see "Teacher"
    And I should see "Non-editing teacher"

  @javascript
  Scenario: Do not allow managers to view any roles but manager and check they are hidden
    Given I log in as "admin"
    And I navigate to "Define roles" node in "Site administration > Users > Permissions"
    And I follow "Edit Manager role"
    And I set the following fields to these values:
      | Allow role to view | Non-editing teacher |
    And I press "Save changes"
    And I log out

    Given I log in as "manager1"
    And I follow "Course 1"
    And I navigate to "Add a new badge" node in "Course administration > Badges"
    And I set the following fields to these values:
      | Name          | Test Badge             |
      | Description   | Test badge description |
      | issuername    | Test Badge Site        |
      | issuercontact | testuser@example.com   |
    And I upload "badges/tests/behat/badge.png" file to "Image" filemanager
    When I press "Create badge"
    And I set the following fields to these values:
      | Add badge criteria | Manual issue by role |
    Then I should not see "Teacher"
    And I should see "Non-editing teacher"