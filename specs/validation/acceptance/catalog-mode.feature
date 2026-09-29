Feature: Catalog mode switching

  @story-2
  Rule: Service2 starts in full mode

    Scenario: Default mode before any switch
      Given Service2 has just started and no mode switch has been requested
      When an API Consumer requests the average score from Service1
      Then the returned average is 35

  @story-2
  Rule: An operator can switch Service2 between full and empty catalog mode

    Scenario: Switching to empty mode
      Given Service2 is serving its full catalog of scored records
      When an Operator switches Service2 to empty mode
      Then Service2 serves a catalog with no records

    Scenario: Switching back to full mode
      Given Service2 is serving an empty catalog
      When an Operator switches Service2 to full mode
      Then Service2 serves its full catalog of ten scored records
