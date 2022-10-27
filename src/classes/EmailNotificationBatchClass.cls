/*
 * 	Description		:	To send monthly transaction details to active contacts
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	08/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 08/10/2022
 * */
global class EmailNotificationBatchClass implements Database.Batchable<sObject> {

    /*
    *
    *   Purpose :   To fetch all contacts
    *               
    */
    global Database.QueryLocator start(Database.BatchableContext BC) {

        return Database.getQueryLocator('SELECT Id, Account_Number__c,Email,StatusPicklist__c, '+
        ' (SELECT Amount__c,Type__c,Transaction_Date__c FROM Transactions__r WHERE Status__c != \'Cancelled\') from Contact WHERE '+
        ' StatusPicklist__c=\'Active\'');
    } 

    /*
    *
    *   Purpose :   To send monthly emails in batches to fetched active contacts for non cancelled transaction.
    *               
    */
    global void execute(Database.BatchableContext BC, List<Contact> scope) {

        //List<Contact> contactList=[];
        List<Decimal> listOfAmount= new List<Decimal>();
        List<String> listOfType= new List<String>();
        List<String> listOfDate= new List<String>();
        List<String> emailAddresses = new List<String>();
        Integer noOfTxns=0;
        String body='';
        for(Contact con : scope){
            Set<String> listOfMailIds = new Set<String>();
            for(Transaction_Entry__c txn : con.Transactions__r){
                Date txnDate=txn.Transaction_Date__c;
                Date dtToday=Date.Today();
                if(txnDate.month()==dtToday.month() && txnDate.year()==dtToday.year()){
                   
                    listOfAmount.add(txn.Amount__c);
                    listOfType.add(txn.type__c );
                    String formattedDate=txnDate.format();
                    listOfDate.add(formattedDate);
                    noOfTxns++;
                }
            }
            if(listOfAmount != null || listOfType != null || listOfDate != null){
           
                body='Your Transaction details for this month is as follows.<br/><br/>';
                body+='<table border=1 cellpadding=5 cellspacing=0><tr><th align=left>'+
                'Account Number</th><th align=left>Debit/Credit</th><th align=left>Amount</th><th align=left>Date</th></tr>';
                for(Integer i=0;i<noOfTxns;i++){
                    body+='<tr><td>'+con.Account_Number__c+'</td><td>'+listOfType[i]+'</td><td>'+listOfAmount[i]+'</td><td>'+listOfDate[i]+'</td></tr>';
                }
                body+='</table>';
                emailAddresses.add(con.Email);
            }
            else{
                body='No transaction was done for this month';
            }
            Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
            emailObj.setToAddresses(emailAddresses);
            emailObj.setSubject('Transaction Details For this Month');
            emailObj.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{emailObj});
            listOfAmount.clear();
            listOfType.clear();
            listOfDate.clear();
            emailAddresses.clear();
            noOfTxns=0;
            body='';
        }         
    } 
     
    global void finish(Database.BatchableContext BC) {
        //Not sending transaction email to single user here, because it is a private data of each contact.
    }
}