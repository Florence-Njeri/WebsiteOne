@javascript @vcr
Feature: Editing an event with start date in the past
  As a site user
  In order to be able to update existing activities
  I would like to edit event details

  Background:
    Given I have logged in
    And the "Daily Standup" "weekly" event exists
    And I am on Events index page

  Scenario: Check that edit page reflects initial settings
    And I visit the edit page for the event named "Daily Standup"
    Then the "Repeat ends" selector should be set to "on"

  #TODO: implement this as declarative version of scenario below
  #Scenario: Edit an existing event to never end
  #  Given an existing event
  #  And I set the event to never end
  #  Then the event should never end
  #  And we see the appropriate number of repetitions of the event

  Scenario: Edit an existing event to never end
    And I visit the edit page for the event named "Daily Standup"
    And I select "Repeat ends" to "never"
    And I click the "Save" button
    Then I should be on the event "Show" page for "Daily Standup"
#    And I should see "09:00-09:30 (UTC)"
    And I visit the edit page for the event named "Daily Standup"
    Then the "Repeat ends" selector should be set to "never"

  Scenario: User in non-UTC timezone edits and overrides the timezone of an existing event, and has expected side-effects for user in UTC timezone
    Given an existing event
    And the user is in "US/Hawaii"
    Then the user should see the date and time adjusted for their timezone in the edit form
    And I select "Japan" from the time zone dropdown
    And they save without making any changes
    When the user is in "Etc/UTC"
    Then the user should see the date and time adjusted for their timezone and updated by 19 hours in the edit form

  Scenario: User in non-UTC timezone edits but makes no changes to an existing event, and has no side-effects for user in UTC timezone
    Given an existing event
    And the user is in "US/Hawaii"
    Then the user should see the date and time adjusted for their timezone in the edit form
    And they save without making any changes
    When the user is in "Etc/UTC"
    Then the user should see the date and time adjusted for their timezone in the edit form

  Scenario: User in non-UTC timezone saves an existing event with no changes, during daylight savings
    Given the date is "2014/06/01 09:15:00 UTC"
    And the user is in "Europe/London"
    And edits an event with start date in standard time
    When they save without making any changes
    Then the event date and time should be unchanged

  Scenario: User in UTC timezone edits an existing event, with no changes, that repeats but with end date in the past
    Given it is now past the end date for the event
    And the user is in "Etc/UTC"
    And they edit and save the event without making any changes
    Then the event date and time should be unchanged

  Scenario: User in non-UTC timezone edits an existing event, with no changes, and daylight savings involved, that repeats but with end date in past
    Given daylight savings are in effect and it is now past the end date for the event
    And the user is in "Europe/London"
    And edits an event with start date in standard time
    When they save without making any changes
    Then the event date and time should be unchanged
