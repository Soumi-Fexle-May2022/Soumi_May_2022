/*
 * 	Description		:	To test if the ContactTriggerHandler class is running as expected and throws error if someone gives no or amount
 * 						less than 3000 as available balance
 * 
 *  Code Coverage	:	87%
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	19/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 19/10/2022
 * */
@isTest
private class ContactTriggerHandlerTest {

    /*
    *
    *   Purpose :   To test if ContactTrigger generates validation when someone tries to enter Available Balance less than Rs.3000
    *
    */        
    @isTest static void checkingAvailableBalanceTest(){
        Property__c prop=new Property__c(Name='Sample Property',Status__c='Sample Property Status');
        insert prop;
        
        Account personalAcc = new Account(Name='Axis Bank Account',Property__c=prop.Id);
        insert personalAcc;
        
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit';
        sbiTxnLimit.Maximum_Debit_Allowed_per_Day__c=11000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Month__c=160000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Transaction__c=5100.00;
        insert sbiTxnLimit;
        
        List<Contact> contactListToInsert = new List<Contact>();
        
        Contact con1= new Contact();
        con1.LastName='TestContact23';
        con1.Email='testemail12@gml.com';
        con1.AccountId=personalAcc.Id;
        con1.StatusPicklist__c='Active';
        con1.Available_Balance__c=5100.00;
        con1.Transaction_Limit__c=sbiTxnLimit.Id;
        contactListToInsert.add(con1);
        
        Contact con2= new Contact();
        con2.LastName='TestContact23';
        con2.Email='testemail12@gml.com';
        con2.AccountId=personalAcc.Id;
        con2.StatusPicklist__c='Active';
        con2.Status__c='Test Status';
        con2.Available_Balance__c=2000.00;
        con2.Transaction_Limit__c=sbiTxnLimit.Id;
        contactListToInsert.add(con2);
        
         try{        
            Test.startTest();                              
            insert contactListToInsert;
            Test.stopTest();
        }
        catch(Exception e)
        {        
            Boolean expectedExceptionThrown =  e.getMessage().contains('Min. Baln. should be atleast Rs.3000') ? true : false;            
            System.AssertEquals(expectedExceptionThrown, true);        
        }
    }        
}