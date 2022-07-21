/*
 * 	Description		:	To prefix account type in short with account number and to email the user giving their account details
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	20/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 20/07/2022
 * */
public class BankAccountTriggerHandler {

    /*
    *
    *   Purpose :   To send Congratulations email to customers and to give them their account number
    *
    */
    public static void emailCustomers(List<Bank_Account__c> bankAccNewList){
        List<Messaging.SingleEmailMessage> emailObjects= new List<Messaging.SingleEmailMessage>();
       
        for(Bank_Account__c bankAccNew: bankAccNewList){
            Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
            List<String> emailAddresses = new List<String>();
            emailAddresses.add(bankAccNew.Customer_email__c);
            emailObj.setToAddresses(emailAddresses);
            emailObj.setSubject('Congratulations on new Account creation!');
            emailObj.setPlainTextBody('Dear '+bankAccNew.Customer_Name__c+',\n Your '+bankAccNew.Type__c+' account with '+bankAccNew.Name+' has been created. \n Your account number is '+bankAccNew.Account_Number__c
                                        +'\n Your IFCS Code is '+bankAccNew.IFCS_Code__c+'\n Thank you');
            emailObjects.add(emailObj);
        }
        Messaging.sendEmail(emailObjects);     //Sending bulk emails
    }

    /*
    *
    *   Purpose :   To update bank account number with prefix of Account type abbreviation
    *
    */
    public static void updateAccountNumber(List<Bank_Account__c> bankAccNewList){
        for(Bank_Account__c bankAcc: bankAccNewList){
            if(bankAcc.Type__c=='Savings')
                bankAcc.Account_Number__c='SA-'+bankAcc.Account_Number__c;
            else if(bankAcc.Type__c=='Fixed Deposit')
                bankAcc.Account_Number__c='FD-'+bankAcc.Account_Number__c;
            else if(bankAcc.Type__c=='Salary')
                bankAcc.Account_Number__c='SL-'+bankAcc.Account_Number__c;
            else if(bankAcc.Type__c=='Current')
                bankAcc.Account_Number__c='CN-'+bankAcc.Account_Number__c;

            //No need to bulkify as Before event doesn't need DML statements    
        }
    }
}