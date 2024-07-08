@isTest
private class OpportunityTriggerHelperTest {
    
    @isTest
    static void testAutoStatusUpdatesOnInsert() {
        // Test data setup
        Date today = Date.today();
        Opportunity opp1 = new Opportunity(
            Name = 'Test Opportunity 1',
            CloseDate = today.addDays(20), // Close date within 30 days hence should update to closing
            StageName = 'Prospecting',
            Demo_Completed__c = false
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Test Opportunity 2',
            CloseDate = today.addDays(40), // Close date more than 30 days 
            StageName = 'Prospecting',
            Demo_Completed__c = false
        );
        
        Test.startTest();
        insert new List<Opportunity>{ opp1, opp2 };
            Test.stopTest();
    }
    
    @isTest
    static void testAutoStatusUpdatesOnUpdate() 
    {
        Date today = Date.today();
        Opportunity opp3 = new Opportunity(
            Name = 'Test Opportunity 3',
            CloseDate = today.addDays(40), // Close date within 30 days hence should update to closing
            StageName = 'Prospecting',
            Demo_Completed__c = false
        );
        insert opp3;
        System.debug('Opp3 id->'+opp3.Id);
        opp3.Demo_Completed__c=true;
        Test.startTest();
        update opp3;
        Test.stopTest();       
    }
    
    @isTest
    static void testBatchExecution() {
        // Test data setup
        Date today = Date.today();
        Opportunity opp1 = new Opportunity(
            Name = 'Test Opportunity 1',
            CloseDate = today.addDays(20), // Close date within 30 days hence should update to 'Closing'
            StageName = 'Prospecting'
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Test Opportunity 2',
            CloseDate = today.addDays(40), // Close date more than 30 days, should remain 'Prospecting'
            StageName = 'Prospecting'
        );
        
        insert new List<Opportunity>{ opp1, opp2 };
        Test.startTest();
        
        Test.stopTest();
        
     }
}