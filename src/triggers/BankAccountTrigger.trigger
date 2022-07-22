/*
 * 	Description		:	Works on Bank Account Object to generate auto account number, prefix account number, email customers
 *                      and to stop user from changing account number once created
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	20/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 20/07/2022  (Created before and after insert events)
 *                      V_1.1 - Modified By - Soumi Chakraborty - 22/07/2022 (Included before update events)
 * */
trigger BankAccountTrigger on Bank_Account__c (before insert, after insert, before update) {
    
    if(Trigger.isBefore ){

        //Calling the method to prefix account type in account number
        if(Trigger.isInsert){
            BankAccountTriggerHandler.updateAccountNumberWithPrefix(Trigger.new);
        }

        //Calling the method to stop user from changing the already created Account number
        if(Trigger.isUpdate){
            BankAccountTriggerHandler.stopUpdatingAccNum(Trigger.new,Trigger.oldMap);
        }
    }

    if(Trigger.isAfter ){
        //Calling the method to congratulate and notify customer about their Account number
        if(Trigger.isInsert){
            BankAccountTriggerHandler.emailCustomers(Trigger.new);
        }
    }
}