/*
 * 	Description		:	To validate creation updations of transactions and to update Contact Available balance
 *                      whenever a transaction is made.
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	07/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 07/10/2022
 * 
 * */
trigger TransactionEntryTrigger on Transaction_Entry__c (before insert,before update,after insert, after update) {

    /*
    *
    *   Purpose :   To stop creation or updation of transactions for inactive related contact,
    *               and to stop updation of any transaction fields except Status.
    *               
    */
    if(Trigger.isBefore ){

        if(Trigger.isInsert){
          
            TransactionEntryTriggerHelper.stopTransactionForInactiveUser(Trigger.new);
        }
        if(Trigger.isUpdate){
           
            TransactionEntryTriggerHelper.stopUpdationOdCertainFields(Trigger.new, Trigger.oldMap);
        }
    }

    /*
    *
    *   Purpose :   To perform transaction for Active contacts and to readjust available balance once a 
    *               transaction is Status field is marked Cancelled from Completed state.
    *               
    */
    if(Trigger.isAfter ){
       
        if(Trigger.isInsert || Trigger.isUpdate){
          
            TransactionEntryTriggerHelper.performTransaction(Trigger.new);
        }
        if(Trigger.isUpdate){
            
            TransactionEntryTriggerHelper.readjustBalanceForCancelledTransactions(Trigger.new, Trigger.oldMap);
        }
    }
}