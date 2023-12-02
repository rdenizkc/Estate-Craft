public with sharing class  BirthDayEmail implements Database.Batchable <sObject>, Schedulable{
    public Database.QueryLocator start(Database.BatchableContext BC) {

       Date brthDay=Date.Today();

        return Database.getQueryLocator([SELECT FirstName, LastName, Birthdate, Email
                                         FROM Contact
                                         WHERE Birthdate=:brthDay ]);

    }



    public void execute(Database.BatchableContext BC ,List<Contact> conList){
 
        if(conList.size()>0){

            List<messaging.SingleEmailMessage> emailList = new List<messaging.SingleEmailMessage>();

            List<String> toAddresses = new List<String>();


            for(Contact con: conList){
           
           
                toAddresses.add(con.Email);

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    email.setToAddresses(toAddresses);
    email.setSubject('Happy BirthDay');
    email.setPlainTextBody('Hello '+ con.FirstName + ',' +' /n' + 'HappyBirthDay!!!!' );
    
    emailList.add(email);

        }
      Messaging.sendEmail(emailList);  
    }

    }
    public void  finish(Database.BatchableContext BC){



    }

    public void execute(SchedulableContext sc){ 


        BirthDayEmail batch1 =new BirthDayEmail(); 
        Database.executeBatch(Batch1 , 20);

    }
}