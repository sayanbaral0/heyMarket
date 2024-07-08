public class OpportunityTriggerHelper {
    public static boolean hasTriggerRan=false;
    public static void autoStatusUpdates(Map<Id,Opportunity> oldOpp,Map<Id,Opportunity> newOpp)
    {
        Opportunity oppToUpdate=new Opportunity();
        List<Opportunity> oppsToUpdate=new List<Opportunity>();
        
        if(!hasTriggerRan)
        {
            hasTriggerRan= true;
            for(Id key: newOpp.keySet())
            {
                oppToUpdate=new Opportunity();
                Opportunity opp=newOpp.get(key);
                if(!opp.isClosed)
                {
                    if( opp.StageName!='Closing')
                    {
                        if(Date.today().addDays(30)>=opp.CloseDate)
                        {
                            
                            oppToUpdate.Id=opp.Id;
                            oppToUpdate.StageName='Closing';
                            oppsToUpdate.add(oppToUpdate);
                        }
                        if(opp.Demo_Completed__c==true && oldOpp.containsKey(key)&& oldOpp.get(key).Demo_Completed__c!=true)
                        {
                            oppToUpdate.Id=opp.Id;
                            oppToUpdate.StageName='Qualification';
                            oppsToUpdate.add(oppToUpdate);
                        }
                        
                    }
                    
                }
                
            }
        }
        if(!oppsToUpdate.isEmpty())
        {
            update oppsToUpdate;
        }
        
    }
}