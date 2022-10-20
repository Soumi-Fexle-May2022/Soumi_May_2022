/*
 * 	Description		:	To perform transaction, fire validation for transaction entry for inactive contact,
 *                      and validation that fires if someone updates Transaction Entry field except Status.Also to readjust balance
 *                      once a transaction is updated as cancelled.
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	07/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 07/10/2022
 * */
public with sharing class  TransactionEntryTriggerHelper {

    /*
    *
    *   Purpose :   To throw a validation if the respective Contact status in Inactive,
    *               and to stop updation of transaction fields except status.
    *               
    */
    public static void stopTransactionForInactiveUser(List<Transaction_Entry__c> newTransactions){

        List<Id> contactIdList = new List<Id>();
        List<Id> inactiveContactIdList = new List<Id>();
        for(Transaction_Entry__c eachTransaction : newTransactions){
            contactIdList.add(eachTransaction.Contact__c);
            if(eachTransaction.Transaction_Date__c>Date.today()){
                eachTransaction.Status__c='Pending';
            }
        }
        List<Contact> parentInactiveContactsList =[SELECT StatusPicklist__c FROM Contact WHERE StatusPicklist__c ='Inactive' AND Id In: contactIdList];
        for(Contact inactiveContact :parentInactiveContactsList){
            inactiveContactIdList.add(inactiveContact.Id);
        }
        for(Transaction_Entry__c eachNewTransaction : newTransactions){
            if(inactiveContactIdList.contains(eachNewTransaction.Contact__c)){
                /* eachTransaction.Status__c='Cancelled'; */
                eachNewTransaction.addError('Cannot proceed with transaction as Related Contact is Inactive');
            }
        }
    }

    /*
    *
    *   Purpose :   To throw a validation if somone tries to update any field except Status field of the transactopn Entry Object
    *               
    */
    public static void stopUpdationOdCertainFields(List<Transaction_Entry__c> newTransactions, Map<Id,Transaction_Entry__c> oldTransactionsMap){

        List<Id> contactIdList = new List<Id>();
        List<Id> inactiveContactIdList = new List<Id>();
        for(Transaction_Entry__c eachTransaction : newTransactions){

            contactIdList.add(eachTransaction.Contact__c);
        }
        List<Contact> parentInactiveContactsList =[SELECT StatusPicklist__c FROM Contact WHERE StatusPicklist__c ='Inactive' AND Id In: contactIdList];
        for(Contact inactiveContact :parentInactiveContactsList){

            inactiveContactIdList.add(inactiveContact.Id);
        }
        for(Transaction_Entry__c eachNewTransaction : newTransactions){
            if(inactiveContactIdList.contains(eachNewTransaction.Contact__c)){

                eachNewTransaction.addError('Cannot update the transaction as Related Contact is Inactive');
            }
            else{

                Transaction_Entry__c eachOldTransaction=oldTransactionsMap.get(eachNewTransaction.Id);
                if(eachOldTransaction.Amount__c!=eachNewTransaction.Amount__c){
                    eachNewTransaction.addError('Cannot edit any field except Status');
                }
                else if(eachOldTransaction.Type__c!=eachNewTransaction.Type__c){
                    eachNewTransaction.addError('Cannot edit any field except Status');
                }
                else if(eachOldTransaction.Transaction_Date__c!=eachNewTransaction.Transaction_Date__c){
                    eachNewTransaction.addError('Cannot edit any field except Status');
                }
                else if(eachOldTransaction.Contact__c!=eachNewTransaction.Contact__c){
                    eachNewTransaction.addError('Cannot edit any field except Status');
                }                
            }
        }
    }

    /*
    *
    *   Purpose :   To perform transaction according to various criteria for Contact with Status as Active.
    *               
    */
    public static void performTransaction(List<Transaction_Entry__c> newTransactions) {

        List<Id> transactionIdList = new List<Id>();
        List<Id> idOfSuccessfullTxnEntries= new List<Id>();
        List<Transaction_Entry__c> transactionIdsWithPerTxnLimit = new List<Transaction_Entry__c>();
        Integer numOfTransactionsInAMonth=0;
        Integer numOfTransactionsInADay=0;
        Decimal sumOfDebitTransactionsInAMonth=0;
        Decimal sumOfDebitTransactionsInADay=0;
        List<Contact> contactListToUpdate=new List<Contact>();
        Map<Id,Decimal> mapOfTxnAmtWithContactId=new Map<Id,Decimal>();

        for(Transaction_Entry__c eachTransaction : newTransactions){

            if(eachTransaction.Status__c=='Completed'){
                transactionIdList.add(eachTransaction.Id);
            }
        }

        List<Transaction_Entry__c> fetchedTransactionList = [SELECT Id,Name,Amount__c,Type__c,Transaction_Date__c,Status__c,Contact__c,Contact__r.Email,
                                                           Contact__r.Account_Number__c, Contact__r.Available_Balance__c,Contact__r.StatusPicklist__c,
                                                           Contact__r.Transaction_Limit__c,Contact__r.Transaction_Limit__r.Name,  
                                                           Contact__r.Transaction_Limit__r.Maximum_Debit_Allowed_per_Day__c,
                                                           Contact__r.Transaction_Limit__r.Maximum_Debit_Allowed_per_Month__c,
                                                           Contact__r.Transaction_Limit__r.Maximum_Debit_Allowed_per_Transaction__c,
                                                           Contact__r.Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c,
                                                           Contact__r.Transaction_Limit__r.Maximum_Transactions_Allowed_per_Month__c
                                                           FROM Transaction_Entry__c WHERE Status__c ='Completed' AND Contact__r.StatusPicklist__c='Active' 
                                                           AND Id IN: transactionIdList];   

       
        List<AggregateResult> resultForTotTxns=[SELECT Contact__r.Id,Transaction_Date__c day, calendar_month(Transaction_Date__c) month, 
                                                calendar_year(Transaction_Date__c) year, COUNT(Name) totTxns FROM Transaction_Entry__c 
                                                WHERE Status__c='Completed' AND Contact__r.StatusPicklist__c='Active' 
                                                GROUP BY Contact__r.Id,Transaction_Date__c, calendar_month(Transaction_Date__c),
                                                 calendar_year(Transaction_Date__c)];
        //2 seperate aggregateResult lists because tot txns consists of both debit and credit txns unlike total debit transaction aggregate result.
        List<AggregateResult> resultForTotAmt=[SELECT Contact__r.Id,Transaction_Date__c day,
                                        calendar_month(Transaction_Date__c) month,calendar_year(Transaction_Date__c) year,
                                        SUM(Amount__c) totAmount FROM Transaction_Entry__c WHERE Status__c='Completed' 
                                        AND Type__c='Debit' AND Contact__r.StatusPicklist__c='Active' 
                                        GROUP BY Contact__r.Id,Transaction_Date__c, calendar_month(Transaction_Date__c),
                                        calendar_year(Transaction_Date__c)];                                

        for(Transaction_Entry__c eachFetchedTransaction: fetchedTransactionList){
            if(transactionIdList.contains(eachFetchedTransaction.Id)){
                //txn from trigger.new

                if(eachFetchedTransaction.Contact__r.StatusPicklist__c=='Active'){
                    //Contact is active

                    if( eachFetchedTransaction.Type__c=='Credit' || 
                    eachFetchedTransaction.Contact__r.Transaction_Limit__r.Maximum_Debit_Allowed_per_Transaction__c>=eachFetchedTransaction.Amount__c){
                        //Per txn debit Limit not crossed

                        Integer yearOfCurrentTxnEntry=eachFetchedTransaction.Transaction_Date__c.year();
                        Integer monthOfCurrentTxnEntry=eachFetchedTransaction.Transaction_Date__c.month();
                        for(AggregateResult result: resultForTotTxns){

                            if(((Integer)result.get('year'))==yearOfCurrentTxnEntry && ((Integer)result.get('month'))==monthOfCurrentTxnEntry &&
                            (Id)result.get('Id')==eachFetchedTransaction.Contact__c){
                                //Debit and Credit Txns of same month

                                numOfTransactionsInAMonth+=(Integer)result.get('totTxns');
                                if((Date)result.get('day')==eachFetchedTransaction.Transaction_Date__c){
                                    //Debit and Credit Txns of same day

                                    numOfTransactionsInADay+=(Integer)result.get('totTxns');
                                }
                            } 
                        }
                        if((eachFetchedTransaction.Contact__r.Transaction_Limit__r.Maximum_Transactions_Allowed_per_Month__c >= numOfTransactionsInAMonth ||
                        eachFetchedTransaction.Contact__r.Transaction_Limit__r.Maximum_Transactions_Allowed_per_Month__c == null) &&
                        (eachFetchedTransaction.Contact__r.Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c>=numOfTransactionsInADay ||
                        eachFetchedTransaction.Contact__r.Transaction_Limit__r.Maximum_Transactions_Allowed_per_Day__c == null)){
                            //Monthly and daily txn number limit not crossed , also null values are checked since these were non req fields.
                            
                            for(AggregateResult result: resultForTotAmt){

                                if(((Integer)result.get('year'))==yearOfCurrentTxnEntry && ((Integer)result.get('month'))==monthOfCurrentTxnEntry &&
                                ((Id)result.get('Id'))==eachFetchedTransaction.Contact__c){                                  
                                    //Debit transaction of a month

                                    sumOfDebitTransactionsInAMonth+=(Decimal)result.get('totAmount');
                                    if((Date)result.get('day')==eachFetchedTransaction.Transaction_Date__c){
                                        //Debit transaction of a day

                                        sumOfDebitTransactionsInADay+=(Decimal)result.get('totAmount');
                                    }
                                } 
                            }
                        }
                        if(eachFetchedTransaction.Type__c=='Credit' ||
                         (eachFetchedTransaction.Contact__r.Transaction_Limit__r.Maximum_Debit_Allowed_per_Month__c>=sumOfDebitTransactionsInAMonth && 
                         eachFetchedTransaction.Contact__r.Transaction_Limit__r.Maximum_Debit_Allowed_per_Day__c>=sumOfDebitTransactionsInADay)){
                            //Monthly and Daily Debit Limit not crossed

                            if(eachFetchedTransaction.Type__c=='Debit' &&
                             eachFetchedTransaction.Contact__r.Available_Balance__c>eachFetchedTransaction.Amount__c &&
                             (eachFetchedTransaction.Contact__r.Available_Balance__c-eachFetchedTransaction.Amount__c)>=3000){
                                //Processing debit
                                
                                idOfSuccessfullTxnEntries.add(eachFetchedTransaction.Id);
                                //Using map to handle bulk insertions
                                if(mapOfTxnAmtWithContactId.containsKey(eachFetchedTransaction.Contact__c)==false){

                                    eachFetchedTransaction.Contact__r.Available_Balance__c-=eachFetchedTransaction.Amount__c;
                                    mapOfTxnAmtWithContactId.put(eachFetchedTransaction.Contact__c, eachFetchedTransaction.Contact__r.Available_Balance__c);
                                }else{
                                    Decimal balance=mapOfTxnAmtWithContactId.get(eachFetchedTransaction.Contact__c);
                                    balance=balance - eachFetchedTransaction.Amount__c;                                                     
                                    mapOfTxnAmtWithContactId.put(eachFetchedTransaction.Contact__c, balance);
                                }
                                
                                //contactListToUpdate.add(contactToUpdate);
                            }
                            else if(eachFetchedTransaction.Type__c=='Credit'){
                                //Processing credit

                                idOfSuccessfullTxnEntries.add(eachFetchedTransaction.Id);
                                //Using map to handle bulk insertions
                                if(mapOfTxnAmtWithContactId.containsKey(eachFetchedTransaction.Contact__c)==false){

                                    eachFetchedTransaction.Contact__r.Available_Balance__c+=eachFetchedTransaction.Amount__c;
                                    mapOfTxnAmtWithContactId.put(eachFetchedTransaction.Contact__c, eachFetchedTransaction.Contact__r.Available_Balance__c);
                                }else{

                                    Decimal balance=mapOfTxnAmtWithContactId.get(eachFetchedTransaction.Contact__c);
                                    balance=balance + eachFetchedTransaction.Amount__c;                                                     
                                    mapOfTxnAmtWithContactId.put(eachFetchedTransaction.Contact__c, balance);
                                }
                            }
                        }
                    }
                }
            }
        }
        for(Id idOdContactToUpdate : mapOfTxnAmtWithContactId.keySet()){
            Contact con =new Contact();
            con.Id=idOdContactToUpdate;
            con.Available_Balance__c=mapOfTxnAmtWithContactId.get(idOdContactToUpdate);
            contactListToUpdate.add(con);
        }
        if(contactListToUpdate.size()>0){
            update contactListToUpdate;
        }
        List<Transaction_Entry__c> successfullTxnEntries = [SELECT Id,Amount__c,Type__c,Transaction_Date__c,Contact__r.FirstName,Contact__r.LastName,
                                                    Contact__r.Email,Contact__r.Account_Number__c, Contact__r.Available_Balance__c,Contact__r.AccountId FROM Transaction_Entry__c
                                                     WHERE Id IN: idOfSuccessfullTxnEntries];
        List<Id> listOfAccIds=new List<Id>();                                             
        for(Transaction_Entry__c successfullTransaction: successfullTxnEntries){
            listOfAccIds.add(successfullTransaction.Contact__r.AccountId);
        }                                             
        List<Account> accList=[SELECT Name FROM Account WHERE Id In:listOfAccIds];  
        Map<Id,String> mapOfAccNamesWithId=new Map<Id,String>();   
        for(Account acc : accList){
            mapOfAccNamesWithId.put(acc.Id,acc.Name);
        } 
        String bankAcc;                                
        try{
            List<Messaging.SingleEmailMessage> emailObjects= new List<Messaging.SingleEmailMessage>();
            for(Transaction_Entry__c successfullTransaction: successfullTxnEntries){
                Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
                List<String> emailOfSingleContact=new List<String>();
                
                if(successfullTransaction.Contact__r.AccountId==null){
                    bankAcc='';
                }else{
                    bankAcc=mapOfAccNamesWithId.get(successfullTransaction.Contact__r.AccountId);
                }
                String accNum=successfullTransaction.Contact__r.Account_Number__c;
                emailOfSingleContact.add(successfullTransaction.Contact__r.Email);
                emailObj.setToAddresses(emailOfSingleContact);
                emailObj.setSubject('Hello, '+successfullTransaction.Contact__r.FirstName+' '+successfullTransaction.Contact__r.LastName+
                            ', your '+bankAcc+' A/c has been '+successfullTransaction.Type__c+'ed.');
                emailObj.setPlainTextBody('Dear '+successfullTransaction.Contact__r.FirstName+' '+successfullTransaction.Contact__r.LastName+',\n\nYour A/c XXX'+
                accNum.substringAfter('-').right(2)+' has been '+successfullTransaction.Type__c+'ed by Rs.'+
                                    successfullTransaction.Amount__c+' on '+successfullTransaction.Transaction_Date__c.format()+'. Available balance is now Rs.'+
                                    successfullTransaction.Contact__r.Available_Balance__c+'.\n\nThank you.');                                                                    
                emailObjects.add(emailObj);
            }
            Messaging.sendEmail(emailObjects); 
        }catch(Exception e){
            System.debug('Daily mailing limit is 15 , see error message -> '+e.getMessage());
        }             
    }

    /*
    *
    *   Purpose :   To readjust available balance once a transaction is marked Cancelled from Completed state
    *               
    */
    public static void readjustBalanceForCancelledTransactions(List<Transaction_Entry__c> newTransactionsList, Map<Id,Transaction_Entry__c> oldTransactionsMap){
        
        List<Id> idListOfCancelledTransactions=new List<Id>();
        Map<Id,Decimal> mapOfTxnAmtWithContactId=new Map<Id,Decimal>();
        List<Contact> contactListToBeReadjusted= new List<Contact>();
        for(Transaction_Entry__c eachNewTransaction : newTransactionsList){
            Transaction_Entry__c eachOldTransaction= oldTransactionsMap.get(eachNewTransaction.Id);
            if(eachOldTransaction.Status__c=='Completed' && eachNewTransaction.Status__c=='Cancelled'){
                idListOfCancelledTransactions.add(eachOldTransaction.Id);          
            }
        }
        List<Transaction_Entry__c> listOfTxnsWithContacts = [SELECT Amount__c, Type__C, Contact__r.Available_Balance__c, Contact__r.StatusPicklist__c FROM Transaction_Entry__c
                                                            WHERE Id In:idListOfCancelledTransactions AND Contact__r.StatusPicklist__c = 'Active'];
        for(Transaction_Entry__c eachTransaction : listOfTxnsWithContacts){
            //Re adjusting balance for Cancelled transactions;
            if(eachTransaction.Type__c=='Debit'){

                if(mapOfTxnAmtWithContactId.containsKey(eachTransaction.Contact__c)==false){

                    eachTransaction.Contact__r.Available_Balance__c+=eachTransaction.Amount__c;
                    mapOfTxnAmtWithContactId.put(eachTransaction.Contact__c, eachTransaction.Contact__r.Available_Balance__c);
                }else{
                    Decimal balance=mapOfTxnAmtWithContactId.get(eachTransaction.Contact__c);
                    balance=balance + eachTransaction.Amount__c;                                                     
                    mapOfTxnAmtWithContactId.put(eachTransaction.Contact__c, balance);
                }
            }
            else if(eachTransaction.Type__c=='Credit'){

                if(mapOfTxnAmtWithContactId.containsKey(eachTransaction.Contact__c)==false){

                    eachTransaction.Contact__r.Available_Balance__c-=eachTransaction.Amount__c;
                    mapOfTxnAmtWithContactId.put(eachTransaction.Contact__c, eachTransaction.Contact__r.Available_Balance__c);
                }else{
                    Decimal balance=mapOfTxnAmtWithContactId.get(eachTransaction.Contact__c);
                    balance=balance - eachTransaction.Amount__c;                                                     
                    mapOfTxnAmtWithContactId.put(eachTransaction.Contact__c, balance);
                }
            }
        } 
        for(Id idOdContactToUpdate : mapOfTxnAmtWithContactId.keySet()){
            Contact con =new Contact();
            con.Id=idOdContactToUpdate;
            con.Available_Balance__c=mapOfTxnAmtWithContactId.get(idOdContactToUpdate);
            contactListToBeReadjusted.add(con);
        }
        if(contactListToBeReadjusted.size()>0){
            update contactListToBeReadjusted;
        }                                                   
    }
}