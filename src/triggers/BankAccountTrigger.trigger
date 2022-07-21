/*
 * 	Description		:	Works on Bank Account Object to update account number and email customers
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	20/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 20/07/2022
 * */
trigger BankAccountTrigger on Bank_Account__c (before insert, after insert) {
    
    //Calling the method to prefix account type in account number
    if(Trigger.isBefore && Trigger.isInsert){
        BankAccountTriggerHandler.updateAccountNumber(Trigger.new);
    }

    //Calling the method to congratulate and notify customer about their Account number
    if(Trigger.isAfter && Trigger.isInsert){
        BankAccountTriggerHandler.emailCustomers(Trigger.new);
    }
}