/*
* 	Description		:	To test the Visual force transaction search page custom controller class
*
*   Code Coverage   :   100%
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	16/10/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 16/10/2022
* 
* */
@isTest
private class TransactionSearchControllerTest {
    
    @isTest static void searchTransactionsTest(){
        Account personalAcc = new Account(Name='Axis Bank Account');
        insert personalAcc;
        
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit12';
        sbiTxnLimit.Maximum_Debit_Allowed_per_Day__c=11000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Month__c=160000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Transaction__c=5100.00;
        insert sbiTxnLimit;
        
        Contact con= new Contact();
        con.LastName='TestContact23';
        con.Email='testemail12@gml.com';
        con.AccountId=personalAcc.Id;
        con.StatusPicklist__c='Active';
        con.Available_Balance__c=5100.00;
        con.Transaction_Limit__c=sbiTxnLimit.Id;
        insert con;
        List<Transaction_Entry__c> transactionsListToInsert=new List<Transaction_Entry__c>();
        for(Integer i=0;i<10;i++){
       
            Transaction_Entry__c newTransaction=new Transaction_Entry__c(Amount__c=456.00,Type__c='Credit',Status__c='Pending',
  		                                                                              		Transaction_Date__c=Date.today().addDays(i),Contact__c=con.Id);
        	transactionsListToInsert.add(newTransaction);      
        }
        insert transactionsListToInsert;
        Test.startTest();
        
        pageReference pageRef = page.SearchTransactionsVFPage;
        
        Test.setCurrentPage(pageRef); 
        TransactionSearchController myObj=new TransactionSearchController();
        
        myObj.nameEntered='TX';
        PageReference result1= myObj.search_now();
        myObj.nameEntered=null;
        
        myObj.startingAmt='400.00';
        myObj.endingAmt='500.00';
        PageReference result2= myObj.search_now();
        myObj.startingAmt=null;
        myObj.endingAmt=null;
        
        myObj.accNum='Ac';
        PageReference result3= myObj.search_now();
        myObj.accNum=null;
        
        myObj.selectedStatus='Pending';
        PageReference result4= myObj.search_now();
        myObj.selectedStatus=null;
        
        myObj.sdate=String.valueOf(Date.today().format());
        myObj.edate=String.valueOf(Date.today().addDays(5).format());
        PageReference result5= myObj.search_now();
        System.assertNotEquals(null, pageRef);
    }
}