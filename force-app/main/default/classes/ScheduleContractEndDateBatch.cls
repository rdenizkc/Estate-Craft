public with sharing class ScheduleContractEndDateBatch implements Schedulable{
    public void execute(SchedulableContext SC){
        //Execute Batch Class in Schedulable Context...
        ContractEndDateBatch batchContractEnd = new ContractEndDateBatch();
        Database.executeBatch(batchContractEnd, 2);
    //Now, Schedule this batch class with Cron Expression.
    //Step-1: Get the instance of your schedulable class.
    ScheduleContractEndDateBatch scheduleContractBatch = new ScheduleContractEndDateBatch();
    //Step-2: Write your Cron Expression
    String cronExp = '0 30 8 ? * MON-FRI 2023-2024';
    //Step-3: Pass the steps in System.Schedule() method
    System.schedule('Contract Expiration Notification', cronExp, scheduleContractBatch);
    }
}