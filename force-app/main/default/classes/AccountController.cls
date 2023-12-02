public with sharing class AccountController {
  

    @AuraEnabled(cacheable=true)
    
    public static List<Account> getChildAccounts(String parentAccId){
    
    
    return [SELECT Id, Name, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity 
    FROM Account 
    WHERE ParentId =:parentAccId 
    WITH SECURITY_ENFORCED];
    
    
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getChildContactOfChildAccounts(String childAccId){
        //child account Id will be used to call child contacts of child account
        return [SELECT Id, AccountId, Email, Name, MailingStreet, MailingState, MailingPostalCode, MailingCountry, MailingCity 
                        FROM Contact 
                        WHERE AccountId =: childAccId 
                        WITH SECURITY_ENFORCED ];
    }
    
    }