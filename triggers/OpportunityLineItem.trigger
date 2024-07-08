trigger OpportunityLineItem on OpportunityLineItem (after insert,after update) {
	if(Trigger.isAfter)
    {
        OppLineItemTriggerHelper.updateOppAmount(Trigger.newMap);
    }
}