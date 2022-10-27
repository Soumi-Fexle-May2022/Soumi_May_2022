/*
 * 	Description		:	To fetch the selected number of non cancelled transactions for a particular contact using contact Id, date range in separate methods.
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	09/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 09/10/2022
 *                      V_1.1 - Modified By - Soumi Chakraborty - 10/10/2022 (Added second method)
 * */
public class TransactionController {

    public List<Transaction_Entry__c> transactions {get;set;}
    public String startDateString {set;get;}
    public String endDateString {set;get;}
    public Contact contact{set;get;}
    
    //Constructor
    public TransactionController()
    {
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=TransactionDetails.pdf');
    }

    /*
    *
    *   Purpose :   To fetch transaction details for a particular contact and to limit the number of transactions as per selected option by user.
    *               
    */
    @AuraEnabled(cacheable=true)
    public static List<Transaction_Entry__c> findTransactionsByContactId(String contactId, Integer selectedOption) {      

        return [
            SELECT Id,Name,Type__c,Amount__c,Transaction_Date__c, Status__c  
            FROM Transaction_Entry__c 
            WHERE Contact__c=:contactId AND Status__c != 'Cancelled'
            ORDER BY Transaction_Date__c DESC
            LIMIT : selectedOption];
    }

    /*
    *
    *   Purpose :   To fetch transaction details for a particular contact within a particular date range.
    *               
    */
    @AuraEnabled(cacheable=true)
    public static List<Transaction_Entry__c> findTransactionsByDateRange(String contactId, String startDate, String endDate) {  

        Date sDt=date.valueOf(startDate);
        Date eDt=date.valueOf(endDate);
         return [
            SELECT Name,Type__c,Amount__c, Transaction_Date__c, Status__c
            FROM Transaction_Entry__c 
            WHERE Contact__c=:contactId AND Status__c != 'Cancelled' AND Transaction_Date__c >= :sDt AND Transaction_Date__c <= :eDt
            ORDER BY Transaction_Date__c DESC];
    }

    /*
    *
    *   Purpose :   To provide Visualfore page the transaction entry details and their contact details
    *               for generating PDF
    *               
    */
    public void generatePdf(){
        
        Id recordIdOfContact = ApexPages.currentPage().getParameters().get('id');
        Date sDt=date.valueOf(ApexPages.currentPage().getParameters().get('startDate'));
        Date eDt=date.valueOf(ApexPages.currentPage().getParameters().get('endDate'));
        startDateString=String.valueOf(sDt);
        endDateString=String.valueOf(eDt);

        //SOQL
        transactions = [SELECT Id, Name, Type__c,Amount__c, Transaction_Date__c,Status__c,
        Contact__c FROM Transaction_Entry__c WHERE 
        Contact__c =: recordIdOfContact AND Transaction_Date__c >=:sDt 
        AND Transaction_Date__c <=:eDt AND Status__c !='Cancelled'];

        //Contact information for pdf body
        contact = [SELECT Id, Name, Account_Number__c FROM Contact WHERE Id =: recordIdOfContact];
    }

    /*
    *
    *   Purpose :   To send the contact an email containing the PDF attachment for their transaction details
    *               for a date range
    *               
    */
    @AuraEnabled(cacheable=true)
    public static void sendEmailPdf(String startDt,String endDt, String contactRecordId){

        PageReference pageRef = new PageReference('/apex/TransactionPdfPage');
        //PageReference pageRef =page.TransactionPdfPage;
        pageRef.getParameters().put('id',contactRecordId);
        pageRef.getParameters().put('startDate',startDt);
        pageRef.getParameters().put('endDate',endDt);
        Blob body;
        if(Test.isRunningTest()){
            body = blob.valueOf('Unit.Test');
        }
        else{
            body=pageRef.getContent();
        }
        Messaging.SingleEmailMessage smail = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        
        Contact con = [SELECT Id, FirstName, LastName,Email FROM Contact WHERE Id =: contactRecordId];
        smail.setToAddresses(new List<String>{con.Email});
        smail.setSubject('Transaction Details');
        smail.setHtmlBody('Dear '+con.FirstName+' '+con.LastName +',<br><br> Please find the attached Transaction details pdf. \nThank you');
        smail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
        attach.setContentType('application/pdf');
        attach.setFileName('TransactionDetails.pdf');
        attach.setBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{smail});
    }
}