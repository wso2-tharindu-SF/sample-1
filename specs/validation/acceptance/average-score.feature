Feature: Average score

  @story-1
  Rule: Service1 returns the average of Service2's current catalog as a whole number

    Scenario: Average of the full catalog
      Given Service2 is serving its full catalog of scored records
      When an API Consumer requests the average score from Service1
      Then the returned average is 35

  @story-1
  Rule: The same average computation runs for whichever catalog Service2 is currently serving

    Scenario: Requesting the average again after Service2's catalog changes
      Given Service2 is serving its full catalog of scored records
      And an API Consumer has already requested the average score from Service1
      When Service2's catalog changes and the API Consumer requests the average score again
      Then Service1 computes the average from whichever catalog Service2 is serving at request time
