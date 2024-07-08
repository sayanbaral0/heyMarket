@isTest
public class LeadTriggerHelperTest {
    @isTest
    static void beforeUpdateHelper() {
        // Create test leads
        Lead lead1 = new Lead(LastName='Doe', Company='Acme Inc.', Email='johndoe@acme.com', Phone='1234567890');
        Lead lead2 = new Lead(LastName='Smith', Company='Acme Inc.', Email='invalidemail@test.com', Phone='1234567890');
        Lead lead3 = new Lead(LastName='Johnson', Company='Acme Inc.', Email='johnson@acme.com', Phone='invalidphone');
        Lead lead4 = new Lead(LastName='Brown', Company='Acme Inc.', Email='', Phone='1234567890');
        Lead lead5 = new Lead(LastName='Williams', Company='Comp101', Email='williams@acme.com', Phone='1234567890');
		List<Lead> listLeads=new List<Lead>{lead1, lead2, lead3, lead4, lead5 };
        insert listLeads;
        List<Database.LeadConvert> leadConverts=new List<Database.LeadConvert>();
        for(Lead lead:listLeads)
        {
            Database.LeadConvert lc = new Database.LeadConvert();
            //lead.Status='Closed - Converted';
            lc.setLeadId(lead.Id);
            for(leadStatus ls: [Select Id, MasterLabel from LeadStatus where IsConverted=true]){
                lc.setConvertedStatus(ls.MasterLabel);
            }
            leadConverts.add(lc);
        }
        

        Test.startTest();
       	//List<Database.SaveResult> resultUpdate = Database.update(listLeads, true);
       	List<Database.LeadConvertResult> results = Database.convertLead(leadConverts, true);
        Test.stopTest();
    }
}