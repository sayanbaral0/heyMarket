trigger OpportunityTrigger on Opportunity (after update, after insert) {
    if(Trigger.isAfter)
    {    
        OpportunityTriggerHelper.autoStatusUpdates(Trigger.oldMap,Trigger.newMap);
    }
    
    
}