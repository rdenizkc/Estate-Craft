trigger OpportunityTrigger on Opportunity (after update, before insert) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        
        OpportunityTriggerHandler.createContract(Trigger.new, Trigger.oldMap);
            
    }
    
    if(Trigger.isBefore && Trigger.isInsert){
        
        OpportunityTriggerHandler.mapTeamMembers(Trigger.new);
            
    }
    
}