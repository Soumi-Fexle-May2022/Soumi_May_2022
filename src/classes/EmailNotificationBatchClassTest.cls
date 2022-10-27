/*
 * 	Description		:	To test if the batch class for sending monthly transaction mail to respective customers is working as expected.
 * 
 *  Code Coverage   :   97% 
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	17/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 17/10/2022
 * */
@isTest
private class EmailNotificationBatchClassTest {
    
    @isTest static void sendMonthlyEmailTest(){
        Account personalAcc = new Account(Name='Axis Bank Account');
        insert personalAcc;
        
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit';
        sbiTxnLimit.Maximum_Debit_Allowed_per_Day__c=11000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Month__c=160000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Transaction__c=5100.00;
        insert sbiTxnLimit;
    	
        List<Contact> contactListToInsert=new List<Contact>();
        
        for(Integer i=1;i<=2;i++){
            Contact con=new Contact(LastName='TestContact'+i,Email='testemail'+i+'@gml.com',AccountId=personalAcc.Id,StatusPicklist__c='Active',Available_Balance__c=5100.00,
                                  Transaction_Limit__c=sbiTxnLimit.Id );
            contactListToInsert.add(con);
        }
        insert contactListToInsert;
        List<Transaction_Entry__c> transactionsListToInsert=new List<Transaction_Entry__c>();
        for(Contact con: contactListToInsert){
            for(Integer i=1;i<=3;i++){
       
            Transaction_Entry__c newTransaction=new Transaction_Entry__c(Amount__c=456.00,Type__c='Credit',Status__c='Completed',
  		                                                                              		Transaction_Date__c=Date.today(),Contact__c=con.Id);
        	transactionsListToInsert.add(newTransaction);            
        	}
        }
        
        insert transactionsListToInsert;
        
        Test.startTest();
        EmailNotificationBatchClass obj = new EmailNotificationBatchClass();
        DataBase.executeBatch(obj); 
       	Test.stopTest();        
        
    }
}