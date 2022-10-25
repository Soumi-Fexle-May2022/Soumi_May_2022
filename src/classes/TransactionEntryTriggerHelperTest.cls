/*
 * 	Description		:	To test if the Transaction Trigger is working properly
 *
 *   Code Coverage   :   96%
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	15/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 15/10/2022
 * */
@isTest
private class TransactionEntryTriggerHelperTest {

    /*
    *
    *   Purpose :   To test if validation fires when transaction with inactive contact is tried to be created.
    *               
    */
    @isTest static void transactionEntryForInactiveContactTest() {
        Contact inactiveContact = new Contact();
        inactiveContact.FirstName='TestInactive';
        inactiveContact.LastName='SampleContact1';
        inactiveContact.StatusPicklist__c='Inactive';
        inactiveContact.Email='sample@gml.com';
        insert inactiveContact;
        Transaction_Entry__c transactionForInactiveContact = new Transaction_Entry__c(Amount__c=300.00,Type__c='Credit',Status__c='Completed',
                                                                                      		Transaction_Date__c=System.today(),Contact__c=inactiveContact.Id);                
        try{        
            Test.startTest();                              
            insert transactionForInactiveContact;
            Test.stopTest();
        }
        catch(Exception e)
        {        
            Boolean expectedExceptionThrown =  e.getMessage().contains('Cannot proceed with transaction as Related Contact is Inactive') ? true : false;            
            System.AssertEquals(expectedExceptionThrown, true);        
        }
    }

    /*
    *
    *   Purpose :   To test if transaction with future date is set to "Pending" status
    *               
    */
    @isTest static void futureTransactionEntryT(){
        Contact activeContact = new Contact();
        activeContact.FirstName='TestActive';
        activeContact.LastName='SampleCont2';
        activeContact.StatusPicklist__c='Active';
        activeContact.Email='samp@gml.com';
        insert activeContact;
        Transaction_Entry__c transactionOnFutureDate = new Transaction_Entry__c(Amount__c=300.00,Type__c='Debit',Status__c='Completed',
  		                                                                              		Transaction_Date__c=Date.today().addDays(3),Contact__c=activeContact.Id);
        
        insert transactionOnFutureDate;
        Transaction_Entry__c transactionAfterInsert=[SELECT Status__c FROM Transaction_Entry__c WHERE Id =:transactionOnFutureDate.Id];
        System.assertEquals('Pending',transactionAfterInsert.Status__c);
    }

    /*
    *
    *   Purpose :   To test if validation fires when we try to change a field except Status field.
    *               
    */
    @isTest static void updatingTxnFieldsExceptStatusTest(){
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit';
        sbiTxnLimit.Maximum_Debit_Allowed_per_Day__c=10000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Month__c=150000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Transaction__c=5000.00;
        insert sbiTxnLimit;
        
        Contact activeContact = new Contact();
        activeContact.FirstName='TestActive';
        activeContact.LastName='SampleCont3';
        activeContact.StatusPicklist__c='Active';
        activeContact.Email='samp3@gml.com';
        activeContact.Available_Balance__C=5000.00;
        activeContact.Transaction_Limit__c=sbiTxnLimit.Id;
        insert activeContact;
        
        Contact activeSampleContact = new Contact();
        activeSampleContact.FirstName='TestActive';
        activeSampleContact.LastName='SampleCont4';
        activeSampleContact.StatusPicklist__c='Active';
        activeSampleContact.Email='samp4@gml.com';
        insert activeSampleContact;
   
        List<Transaction_Entry__c> transactionEntries =new List<Transaction_Entry__c>();
        Transaction_Entry__c firstTransaction = new Transaction_Entry__c(Amount__c=300.00,Type__c='Credit',Status__c='Completed',
  		                                                                              		Transaction_Date__c=Date.today(),Contact__c=activeContact.Id);
        insert firstTransaction;
        
		
        List<Transaction_Entry__c> transactionEntriesToUpdate =new List<Transaction_Entry__c>(); 
        try{        
            Test.startTest();       
            firstTransaction.Amount__c=350.00;
            update firstTransaction;
        	Test.stopTest();
        }
        catch(Exception ex)
        {   
           
            Boolean expectedExceptionThrown =  ex.getMessage().contains('Cannot edit any field except Status') ? true : false;            
            System.AssertEquals(expectedExceptionThrown, true);        
        }
    }

    /*
    *
    *   Purpose :   To see if credit transaction is working properly and reflecting in related contact's
    *               available balance.
    *               
    */
    @isTest static void performCreditTransactionTest(){
        
        Account personalAcc = new Account(Name='Axis Bank Account');
        insert personalAcc;
        
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit';
        sbiTxnLimit.Maximum_Debit_Allowed_per_Day__c=11000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Month__c=160000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Transaction__c=5100.00;
        insert sbiTxnLimit;
    	
        List<Contact> contactListToInsert=new List<Contact>();
        
        for(Integer i=1;i<=3;i++){
            Contact con=new Contact(LastName='TestContact'+i,Email='testemail'+i+'@gml.com',AccountId=personalAcc.Id,StatusPicklist__c='Active',Available_Balance__c=5000.00,
                                  Transaction_Limit__c=sbiTxnLimit.Id );
            contactListToInsert.add(con);
        }
        if(contactListToInsert.size()>0){
            insert contactListToInsert;
        }
        
        List<Transaction_Entry__c> transactionsListToInsert=new List<Transaction_Entry__c>();
        for(Contact con: contactListToInsert){
            for(Integer i=1;i<=3;i++){
       
            Transaction_Entry__c newTransaction=new Transaction_Entry__c(Amount__c=100.00,Type__c='Credit',Status__c='Completed',
  		                                                                              		Transaction_Date__c=Date.today(),Contact__c=con.Id);
        	transactionsListToInsert.add(newTransaction);            
        	}
        }
        if(transactionsListToInsert.size()>0){
            insert transactionsListToInsert;
        }
        List<Id> listOfContactIds=new List<Id>();
        for(Contact con: contactListToInsert){
            listOfContactIds.add(con.Id);
        }
        List<Contact> contactsAfterCredit=[SELECT Available_Balance__c FROM Contact WHERE  Id =:listOfContactIds];
        for(Contact updatedContact : contactsAfterCredit){
            System.assertEquals(5300,updatedContact.Available_Balance__c);
        }
    }

    /*
    *
    *   Purpose :   To see if debit transaction is working properly and reflecting in related contact's
    *               available balance. 
    *               
    */
    @isTest static void performDebitTransactionTest(){
        
        Account personalAcc = new Account(Name='Axis Bank Account');
        insert personalAcc;
        
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit';
        sbiTxnLimit.Maximum_Debit_Allowed_per_Day__c=11000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Month__c=160000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Transaction__c=5100.00;
        insert sbiTxnLimit;
    	
        List<Contact> contactListToInsert=new List<Contact>();
        
        for(Integer i=1;i<=3;i++){
            Contact con=new Contact(LastName='TestContact'+i,Email='testemail'+i+'@gml.com',AccountId=personalAcc.Id,StatusPicklist__c='Active',Available_Balance__c=5000.00,
                                  Transaction_Limit__c=sbiTxnLimit.Id );
            contactListToInsert.add(con);
        }
        if(contactListToInsert.size()>0){
            insert contactListToInsert;
        }
        List<Transaction_Entry__c> transactionsListToInsert=new List<Transaction_Entry__c>();
        for(Contact con: contactListToInsert){
            for(Integer i=1;i<=3;i++){
       
            Transaction_Entry__c newTransaction=new Transaction_Entry__c(Amount__c=100.00,Type__c='Debit',Status__c='Completed',
  		                                                                              		Transaction_Date__c=Date.today(),Contact__c=con.Id);
        	transactionsListToInsert.add(newTransaction);            
        	}
        }
        
        if(transactionsListToInsert.size()>0){
            insert transactionsListToInsert;
        }
        List<Id> listOfContactIds=new List<Id>();
        for(Contact con: contactListToInsert){
            listOfContactIds.add(con.Id);
        }
        List<Contact> contactsAfterDebit=[SELECT Available_Balance__c FROM Contact WHERE  Id =:listOfContactIds];
        for(Contact updatedContact : contactsAfterDebit){
            System.assertEquals(4700,updatedContact.Available_Balance__c);
        }
    }

    /*
    *
    *   Purpose :   To see if related contact's available balance is readjusted when a transaction is updated as cancelled.
    *               
    */
    @isTest static void readjustAvailableBalanceTest(){
        
        Account personalAcc = new Account(Name='Axis Bank Account');
        insert personalAcc;
        
        Transaction_Limit__c sbiTxnLimit=new Transaction_Limit__c();
        sbiTxnLimit.Name='My Bank Limit';
        sbiTxnLimit.Maximum_Debit_Allowed_per_Day__c=11000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Month__c=160000.00;
        sbiTxnLimit.Maximum_Debit_Allowed_per_Transaction__c=5100.00;
        insert sbiTxnLimit;
    	
        List<Contact> contactListToInsert=new List<Contact>();
        
        for(Integer i=1;i<=3;i++){
            Contact con=new Contact(LastName='TestContact'+i,Email='testemail'+i+'@gml.com',AccountId=personalAcc.Id,StatusPicklist__c='Active',Available_Balance__c=5000.00,
                                  Transaction_Limit__c=sbiTxnLimit.Id );
            contactListToInsert.add(con);
        }
        if(contactListToInsert.size()>0){
            insert contactListToInsert;
        }
        List<Transaction_Entry__c> transactionsListToInsert=new List<Transaction_Entry__c>();
        for(Contact con: contactListToInsert){
            for(Integer i=1;i<=3;i++){
       
            Transaction_Entry__c newTransaction=new Transaction_Entry__c(Amount__c=100.00,Type__c='Debit',Status__c='Completed',
  		                                                                              		Transaction_Date__c=Date.today(),Contact__c=con.Id);
        	transactionsListToInsert.add(newTransaction);            
        	}
        }
        for(Contact con: contactListToInsert){
            for(Integer i=1;i<=3;i++){
       
            Transaction_Entry__c newTransaction=new Transaction_Entry__c(Amount__c=50.00,Type__c='Credit',Status__c='Completed',
  		                                                                              		Transaction_Date__c=Date.today(),Contact__c=con.Id);
        	transactionsListToInsert.add(newTransaction);            
        	}
        }
        
        if(transactionsListToInsert.size()>0){
            insert transactionsListToInsert;
        }
        List<Transaction_Entry__c> transactionEntriesListToCancel = new List<Transaction_Entry__c>();
        for(Transaction_Entry__c eachTransaction: transactionsListToInsert){
            eachTransaction.Status__c='Cancelled';
            transactionEntriesListToCancel.add(eachTransaction);
        }
        if(transactionEntriesListToCancel.size()>0){
            update transactionEntriesListToCancel;
        }
        
        List<Id> listOfContactIds=new List<Id>();
        for(Contact con: contactListToInsert){
            listOfContactIds.add(con.Id);
        }
        List<Contact> contactsAfterReadjustment=[SELECT Available_Balance__c FROM Contact WHERE  Id =:listOfContactIds];
        for(Contact updatedContact : contactsAfterReadjustment){
            System.assertEquals(5000,updatedContact.Available_Balance__c);
        }
    }
}