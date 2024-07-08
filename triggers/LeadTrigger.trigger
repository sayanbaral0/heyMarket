trigger LeadTrigger on Lead (before insert, before update) {
	LeadTriggerHelper helper=new LeadTriggerHelper();
    if(Trigger.isBefore && Trigger.isInsert)
    {
        helper.beforeCreateHelper(Trigger.new);
    }
     if(Trigger.isBefore && Trigger.isUpdate)
    {
        helper.beforeUpdateHelper(Trigger.oldMap,Trigger.newMap);
    }
    
}