public with sharing class ContractEndDateBatch implements Database.Batchable <sObject>, Database.Stateful {
  
  public Integer counter = 0; // keep the number of records for the emails send
//start method
  public Database.QueryLocator start(Database.BatchableContext BC){  
    //call the contract records whose end date is very soon (in 5 days) : call the email of related users as well
      String contQuery = 'SELECT Id, EndDate,  Leasing_Admin__r.Email, Leasing_Anallyst__r.Email, Asset_Manager__r.Email FROM Contract WHERE EndDate = NEXT_N_DAYS:5 ORDER BY EndDate ASC';
      return Database.getQueryLocator(contQuery);
  }
//execute method
  public void execute(Database.BatchableContext BC, List<Contract> listContract){  
      if(listContract.size()>0){
              List<Messaging.SingleEmailMessage> emailsToBeSent = new List<Messaging.SingleEmailMessage>();
                      for(Contract w :  listContract){
                          Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                                          //prepare the recipients (to, cc or bcc) to Whom? 
                                      List<String> emailMembers = new List<String>();
                          
                                      emailMembers.add(w.Leasing_Admin__r.Email);
                                      emailMembers.add(w.Leasing_Anallyst__r.Email);
                                      emailMembers.add(w.Asset_Manager__r.Email);
                      
                          email.setToAddresses(emailMembers);
                          email.setSubject('Attention! The Contract is expiring soon!');  //prepare the subject of email    
                          email.setPlainTextBody(
                              'Hello,' + '\n'+
                              'Contract End Date: ' + w.EndDate + '\n' +
                              'Please see the contract details from the following link:' + '\n' +
                              'https://techproed-e0-dev-ed.develop.lightning.force.com/lightning/r/Contract/' + w.Id + '/view' + '\n'+
                              'Thank you for your attention on this matter!');
                              emailsToBeSent.add(email);
                              

                              counter++;
                      }
              Messaging.sendEmail(emailsToBeSent);
      }
    }
//finish method
  //finish method
  public void finish(Database.BatchableContext BC){  

    System.debug('The number of Emails Sent: ' + counter);

    AsyncApexJob myBatch = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE Id=: BC.getJobId()];

    System.debug('Job Items Processed: ' + myBatch.JobItemsProcessed);
    System.debug('Status: ' + myBatch.Status); //we send a ummary of batch report...
}
}
/* 
you can check in anonymys window

ContractEndDateBatch endCont = new ContractEndDateBatch();
ID batchEndCont= Database.executeBatch(endCont, 2);
 */