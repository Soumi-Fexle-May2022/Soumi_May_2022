/*
 * 	Description		:	To prefix account type in short with account number and to email the user giving their account details
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	20/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 20/07/2022  (Created the methods -updateAccountNumberWithPrefix(),emailCustomers())
 *                      V_1.1 - Modified By - Soumi Chakraborty - 22/07/2022 (Added the method -stopUpdatingAccNum())
 * */
public class BankAccountTriggerHandler {

    /*
    *
    *   Purpose :   This method updates generates an auto bank account number
    *               then bank account number is with prefixed with Account type abbreviation
    *               eg- Saving Account is prefixed as SA-232344
    *
    */
    public static void updateAccountNumberWithPrefix(List<Bank_Account__c> bankAccNewList){
        Integer num;
        for(Bank_Account__c bankAcc: bankAccNewList){
            num=Integer.valueof((Math.random() * 100000));
            bankAcc.Account_Number__c='666'+num;
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

    /*
    *
    *   Purpose :   To display a custom error message if a user tries to update Account number
    *
    */
    public static void stopUpdatingAccNum(List<Bank_Account__c> bankAccNewList,Map<Id,Bank_Account__c> bankAccOldMap){
        for(Bank_Account__c accNew : bankAccNewList){
            Bank_Account__c accOld = bankAccOldMap.get(accNew.Id);
            if(accNew.Account_Number__c != accOld.Account_Number__c){
                accNew.Account_Number__c.addError('Account number cannot be changed once created');
            }
        }
    }

    /*
    *
    *   Purpose :   To send Congratulations email to customers and to give them their account details
    *
    */
    public static void emailCustomers(List<Bank_Account__c> bankAccNewList){
        try{
            List<Messaging.SingleEmailMessage> emailObjects= new List<Messaging.SingleEmailMessage>();
            for(Bank_Account__c bankAccNew: bankAccNewList){
                Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
                List<String> emailAddresses = new List<String>();
                emailAddresses.add(bankAccNew.Customer_email__c);
                emailObj.setToAddresses(emailAddresses);
                emailObj.setSubject('Congratulations on New Account Creation!');
                emailObj.setPlainTextBody('Dear '+bankAccNew.Name+',\n\nYour '+bankAccNew.Type__c+' account with '+bankAccNew.Bank_Name__c
                                            +' has been created. Your account number is '+bankAccNew.Account_Number__c
                                            +' and your IFCS Code is '+bankAccNew.IFCS_Code__c+'.\n\nThank you.');                           
                emailObjects.add(emailObj);
            }
            Messaging.sendEmail(emailObjects);     //Sending bulk emails
        }catch(Exception e){
            System.debug('Daily mailing limit is 15 , see error message -> '+e.getMessage());
        }
    }
}