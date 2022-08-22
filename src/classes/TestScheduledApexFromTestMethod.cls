/*
* 	Description		:	updates names of accounts at a scheduled time
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	21/08/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 21/08/2022 
* 
* */
global class TestScheduledApexFromTestMethod implements Schedulable {

    // This test runs a scheduled job at midnight Sept. 3rd. 2022
    
       public static String CRON_EXP = '0 0 0 3 9 ? 2022';
       
       global void execute(SchedulableContext ctx) {
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                    FROM CronTrigger WHERE Id = :ctx.getTriggerId()];
    
          System.assertEquals(CRON_EXP, ct.CronExpression);
          System.assertEquals(0, ct.TimesTriggered);
          System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
    
          Account a = [SELECT Id, Name FROM Account WHERE Name = 
                      'testScheduledApexFromTestMethod'];
          a.name = 'testScheduledApexFromTestMethodUpdated';
          update a;
       }   
    }