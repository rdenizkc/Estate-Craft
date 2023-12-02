public with sharing class BatchUserDeactivation implements Database.Batchable <sObject>, Database.Stateful, Schedulable{
 
    Integer numberOfDeactivatedUsers = 0;
    List<String> deactivatedUserNames = new List<String>(); //keep name of deactivated users 
    public Database.QueryLocator start(Database.BatchableContext BC){
        //1st : I need value in custom label to use for going back in time 
        // by using this value we will deactivate users who did not log in for 60 days
        String daysToGoBack = System.Label.UserDeactivationDays; //coming as String
        Integer numberOfDays = Integer.valueOf(daysToGoBack);
        //DateTime.now()
        Date lastAccessDay = System.Today() - numberOfDays; //days are defined to back in time for deactivation
        return Database.getQueryLocator([SELECT Id, Name,LastLoginDate, IsActive, CreatedDate FROM 
                        User WHERE (LastLoginDate <=: lastAccessDay OR (LastLoginDate = null AND CreatedDate <=: lastAccessDay)) AND IsActive = true]);
        }
    //execute method
    public void execute(Database.BatchableContext BC, List<User> userList ){
        if(userList.size()>0){
            for(User u : userList){
                u.IsActive = false; //deactivate the user
                numberOfDeactivatedUsers++;
                deactivatedUserNames.add(u.Name);
            }
            Database.update(userList, false);
            //Syntax: Database.update(list, allOrNothing);
            //allOrNothing = false; If error occurs while updating, that's ok. Just update the ones that have no error end deactivate tehir credentials. 
        }   
    }
    public void finish(Database.BatchableContext BC){
    System.debug('Number Of Deactivated Users : ' + numberOfDeactivatedUsers);
    System.debug('Names Of Deactivated Users: ' + deactivatedUserNames);
    //Send email to your manager with deactivation info
    //STEP1: create an instance of 'Messaging.SingleEmailMessage();'
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
    //for addresses, create a list
    List<String> toEmailAddresses = new List<String>{'mtalhakaya99@gmail.com', 'talha01.techproed@gmail.com'};
    email.setToAddresses(toEmailAddresses);
    email.setSubject('User Deactivation Job');
    email.setPlainTextBody('Hello, '+ '\n'
                            + 'Names Of Deactivated Users: ' +  numberOfDeactivatedUsers  + '\n'  +
                             'Names Of Deactivated Users: ' +  deactivatedUserNames );
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();                 
            emailList.add(email); 
            Messaging.sendEmail(emailList);
    } 
    public void execute(SchedulableContext SC){
        BatchUserDeactivation batch1 = new BatchUserDeactivation();
        Database.executeBatch(batch1, 1);
    }
    }
    //to follow number of records proccesses, what do I need to implement????
    //