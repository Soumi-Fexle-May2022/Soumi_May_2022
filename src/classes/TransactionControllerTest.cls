/*
 * 	Description		:	To test if the Transaction Controller class is returning data properly
 * 
 *  Code Coverage   :   97%
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	15/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 15/10/2022
 * */
@isTest
private class TransactionControllerTest {
    
    @isTest static PageReference retriveTxnsAndSendEmailTest(){
        Account personalAcc = new Account(Name='Axis Bank Account');
        insert personalAcc;
        
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit';
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
        String idOfLastContact;
        for(Integer i=0;i<10;i++){
       
            Transaction_Entry__c newTransaction=new Transaction_Entry__c(Amount__c=456.00,Type__c='Credit',Status__c='Pending',
  		                                                                              		Transaction_Date__c=Date.today().addDays(i),Contact__c=con.Id);
        	idOfLastContact=String.valueOf(con.Id);
        	transactionsListToInsert.add(newTransaction);      
        }
        insert transactionsListToInsert;
		Test.startTest();    
        TransactionController.sendEmailPdf(String.valueOf(Date.today()),String.valueOf(Date.today().addDays(5)),idOfLastContact);
        
        List<Transaction_Entry__c> returnedTransactionsAccToLimit=TransactionController.findTransactionsByContactId(con.Id,5);
        List<Transaction_Entry__c> returnedTransactionsAccToDate=TransactionController.findTransactionsByDateRange(con.Id,String.valueOf(Date.today()),String.valueOf(Date.today().addDays(20)));
        Test.stopTest();
        System.assertEquals(5, returnedTransactionsAccToLimit.size());
        System.assertEquals(10, returnedTransactionsAccToDate.size());
        String urlString = 'https://fexleservices5-dev-ed--c.visualforce.com/';
        String urlWithValues = urlString.substring(0, urlString.indexOf('.com/'));
        urlWithValues = urlWithValues+('.com/apex/TransactionPdfPage?id='+con.Id+'&startDate='+String.valueOf(Date.today())+'&endDate='+String.valueOf(Date.today().addDays(20)));            
        PageReference pageRef = new PageReference(urlWithValues);
        pageRef.setRedirect(true);
        
        Test.setCurrentPage(pageRef);
        TransactionController myObj =new TransactionController();
        myObj.generatePdf();
        return pageRef;
    }
}