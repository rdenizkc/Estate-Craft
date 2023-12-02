// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);


ContractEndDateBatch endCont = new ContractEndDateBatch();
ID batchEndCont= Database.executeBatch(endCont, 2);

//Now, Schedule this batch class with Cron Expression.
    //Step-1: Get the instance of your schedulable class.
    ScheduleContractEndDateBatch scheduleContractBatch = new ScheduleContractEndDateBatch();

    //Step-2: Write your Cron Expression
    String cronExp = '0 30 8 ? * MON-FRI 2023-2024';

    //Step-3: Pass the steps in System.Schedule() method
    System.schedule('Contract Expiration Notification', cronExp, scheduleContractBatch);

