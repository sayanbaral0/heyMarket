@isTest
public class OppLineItemTriggerHelperTest {

    @testSetup
    static void setupTestData() {
        // Create test Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Create test Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity', 
            CloseDate = Date.today().addMonths(1), 
            StageName = 'Prospecting', 
            AccountId = acc.Id
        );
        insert opp;

        // Create test Products
        Product2 prod1 = new Product2(Name = 'Test Product 1', IsActive = true);
        Product2 prod2 = new Product2(Name = 'Test Product 2', IsActive = true);
        insert new List<Product2>{prod1, prod2};
            
        //Fetch Standard pricebook ID
		Id pricebookId = Test.getStandardPricebookId();
 		
        // Create Pricebook Entry
        PricebookEntry pbe1 = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod1.Id, 
            UnitPrice = 100, 
            IsActive = true
        );
        PricebookEntry pbe2 = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod2.Id, 
            UnitPrice = 200, 
            IsActive = true
        );
        insert new List<PricebookEntry>{pbe1, pbe2};       
    }

    @isTest
    static void testUpdateOppAmount() {
        List<Opportunity> opp=[SELECT Id FROM Opportunity];
        List<PricebookEntry> pbEntries=[SELECT Id FROM PriceBookEntry];
        List<OpportunityLineItem> oliList=new List<OpportunityLineItem>();
        OpportunityLineItem oli1 = new OpportunityLineItem(
            OpportunityId = opp[0].Id,
            PricebookEntryId = pbEntries[0].Id,
            Quantity = 1,
            UnitPrice = 100
        );
        OpportunityLineItem oli2 = new OpportunityLineItem(
            OpportunityId = opp[0].Id,
            PricebookEntryId = pbEntries[1].Id,
            Quantity = 2,
            UnitPrice = 200
        );
        oliList.add(oli1);
        oliList.add(oli2);
        Test.startTest();
       	insert oliList;
        
        Test.stopTest();

        // Fetch the updated Opportunity
        Opportunity updatedOpp = [SELECT Id, Amount FROM Opportunity LIMIT 1];
        
       //Check if value is same as the sum of Opportunity Products added 1*100 + 2*200 =500
        System.assertEquals(500, updatedOpp.Amount);
    }
}