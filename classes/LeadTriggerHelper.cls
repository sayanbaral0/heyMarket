public class LeadTriggerHelper {
    public void beforeCreateHelper(List<lead> leads)
    {
        Group salesGroup=[SELECT Id, Name, DeveloperName, Type FROM Group WHERE DeveloperName = 'Sales_Rep_Group' LIMIT 1];
        String assignOwnerId;
        Map<String,Integer> userIdWithLeadCount=new Map<String,Integer>();
        if(salesGroup!=null)
        {
            Map<String,GroupMember> salesGroupMembers=new Map<String,GroupMember>([SELECT GroupId, UserOrGroupId
                                                                                   FROM GroupMember 
                                                                                   WHERE UserOrGroup.isActive=true AND GroupId = :salesGroup.Id]);
            if(salesGroupMembers!=null && salesGroupMembers.size()>0)
            {
                
                for(GroupMember gm:salesGroupMembers.values())
                {
                    //for all active members in group, initialize map with leadcount of each user as 0
                    if(((String)gm.UserOrGroupId).startsWith('005'))
                    {
                        userIdWithLeadCount.put(gm.UserOrGroupId,0);
                    }
                } 
                //Query all exisitng leads owned by member of concerned group
                List<AggregateResult> groupedResults= [SELECT OwnerId, COUNT(Id) leadCount
                                                       FROM Lead WHERE OwnerId IN :userIdWithLeadCount.keySet()
                                                       GROUP BY OwnerId ORDER BY COUNT(Id)];
                
                //For all members, who have leads assign count of leads for each user in map userIdWithLeadCount
                for(AggregateResult ar : groupedResults)
                    userIdWithLeadCount.put((String)ar.get('OwnerId'),(Integer)ar.get('leadCount'));
                
            }
            
        }
        for(Lead l:leads)
        {
            Integer leastCount = null;
            for (String key : userIdWithLeadCount.keySet()) {
                Integer leadCount = userIdWithLeadCount.get(key);
                if (leastCount == null || leadCount < leastCount) {
                    leastCount = leadCount;
                    assignOwnerId = key;
                }
            }     
            if(l.Industry=='Banking')
                l.OwnerId=assignOwnerId;
            	userIdWithLeadCount.put(assignOwnerId,leastCount+1);
            
        } 
        
    }
    
    public void beforeUpdateHelper(Map<Id,lead> oldLeads,Map<Id,Lead> newLeads)
    {
        for(Id key: oldLeads.keySet())
        {
            System.debug(oldLeads.get(key).isConverted+'<---->'+newLeads.get(key).isConverted);
            if(!(oldLeads.get(key).isConverted) && newLeads.get(key).isConverted)
            {
                if(String.isBlank(newLeads.get(key).Phone)||String.isBlank(newLeads.get(key).Email)||
                  String.isBlank(newLeads.get(key).LastName)|| String.isBlank(newLeads.get(key).Company))
                {
                    newLeads.get(key).addError('Ensure to populate the key fields.');
                   	continue;
                }
                if(!LeadTriggerService.isValidEmail(newLeads.get(key).Email))
                {
                    newLeads.get(key).addError('Email ID is invalid.');
                    continue;   
                }
                if(!LeadTriggerService.isValidPhone(newLeads.get(key).Phone))
                {
                    newLeads.get(key).addError('Phone number is invalid.');
                }
            }
        }
    }
}