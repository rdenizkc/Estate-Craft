public class OpportunityTriggerHandler {
    public static void createContract(List<Opportunity> listOpp, Map<Id, Opportunity> mapOpp){
        
        List<Contract> newContracts = new List<Contract>();
        
        for(Opportunity w: listOpp){
            
            if(w.StageName == 'Closed Won' && w.StageName !=  mapOpp.get(w.Id).StageName){
                
                
                
            Contract con = new Contract();
                
                con.AccountId = w.AccountId;
                con.Status = 'Draft';
                con.StartDate = w.CloseDate;
                con.ContractTerm = 12;
                con.Center__c = w.Center__c;
                con.Space__c = w.Space__c;
                con.Leasing_Admin__c = w.Leasing_Admin__c;
                con.Leasing_Anallyst__c = w.Leasing_Anallyst__c;
                con.Asset_Manager__c = w.Asset_Manager__c;
                con.OwnerId = w.OwnerId;
                
                newContracts.add(con);
            } 
        }
        
        insert newContracts;
    }
    
    public static void mapTeamMembers(List<Opportunity> oppList){
        /*
        for(Opportunity w: oppList){
            
            Center__c cntr = [SELECT Id, Name, Leasing_Admin__c, Leasing_Analyst__c, Asset_Manager__c FROM Center__c WHERE Id=:w.Center__c];
            w.Leasing_Admin__c = cntr.Leasing_Admin__c;
            w.Leasing_Analyst__c = cntr.Leasing_Analyst__c;
            w.Asset_Manager__c = cntr.Asset_Manager__c;
        }
        */
        
        Set<String> centerId = new Set<String>();
        
        for(Opportunity w: oppList){
            if(String.isNotBlank(w.Center__c)){
                centerId.add(w.Center__c);
            }
        }
        
        Map<Id, Center__c> mapCenter = new Map<Id, Center__c>([SELECT Id, Name,Leasing_Admin__c, Leasing_Analyst__c, Asset_Manager__c 
                                                               FROM Center__c 
                                                               WHERE Id In:centerId]);
        
        for(Opportunity ww: oppList){
            
            ww.Leasing_Admin__c = mapCenter.get(ww.Center__c).Leasing_Admin__c;
            ww.Leasing_Anallyst__c = mapCenter.get(ww.Center__c).Leasing_Analyst__c;
            ww.Asset_Manager__c = mapCenter.get(ww.Center__c).Asset_Manager__c;
        }
      }
        
    }