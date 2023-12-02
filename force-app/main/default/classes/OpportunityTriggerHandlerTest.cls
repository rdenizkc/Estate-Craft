@isTest
public class OpportunityTriggerHandlerTest {
    @isTest
    static void testCreateContract() {
      

        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today()// Başlangıç aşaması
            );
        insert testOpp;

        // Eski ve yeni Opportunity eşlemesi oluşturun
        Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();
        
        oldOppMap.put(testOpp.Id , testOpp);
        
        opportunity oldOpp=oldOppMap.get(testOpp.Id);
        
        testOpp.StageName='Closed won';
        update testOpp;
     
        // OpportunityTriggerHandler metodunu çağırın
        Test.startTest();
        OpportunityTriggerHandler.createContract(new List<Opportunity>{ testOpp }, oldOppMap);
        Test.stopTest();

        // Sonuçları doğrula
        List<Contract> contracts = [SELECT Id FROM Contract WHERE AccountId = : testOpp.Id];
        System.assertEquals(1, contracts.size(), 'Bir kontrat oluşturulmalıdır');
    } 
}