public class OppLineItemTriggerHelper {
	public static void updateOppAmount(Map<Id,OpportunityLineItem> newOppLineItems)
    {
        Map<Id,Decimal> oppWithLineItems=new Map<Id,Decimal>();
        for(Id oppLIId: newOppLineItems.keySet())
        {
            //Calculate total amount generated from each Line Item
            OpportunityLineItem oli=newOppLineItems.get(oppLIId);
            Decimal lineItemAmount= oli.Quantity*oli.ListPrice;
            
            /*If already an opportunity Id exists in map along with the ammount, add the 
            current line item value to it. Else, add a new entry to the map with Opportunity Id andLine item amount*/
            if(oppWithLineItems.containsKey(oli.OpportunityId))
            {
                Decimal existingAmount=oppWithLineItems.get(oli.OpportunityId);
                oppWithLineItems.put(oli.OpportunityId,existingAmount+lineItemAmount);
            }
            else
            {
                oppWithLineItems.put(oli.OpportunityId,lineItemAmount);
            }
        }
        
        //Query those opportunity whose Ids are present in the map, then update 'Amount' based on value in map
        List<Opportunity> oppsToUpdate=new List<Opportunity>([SELECT Id,Amount FROM Opportunity WHERE Id IN :oppWithLineItems.keySet()]);
        for(Opportunity opp:oppsToUpdate)
        {
            if(oppWithLineItems.containsKey(opp.Id))
            {
                opp.Amount=oppWithLineItems.get(opp.Id);
            }
        }
        
        
        if(oppsToUpdate!=null && oppsToUpdate.size()>0)
        {
            List<Database.Saveresult> results=Database.update(oppsToUpdate, true);
            for(Database.Saveresult sr: results)
            {
                System.debug('Save result-->'+sr);
            }
        }
    
    }
}