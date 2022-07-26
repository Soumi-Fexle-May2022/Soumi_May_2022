/*
 * 	Description		:	This trigger fires whenever an contact related to an account is added or removed, and changes the 
 * 						total number of contacts field in that Account accordingly
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/07/2022
 * 
 * */
trigger ContactTrigger on Contact (after insert,after delete, after undelete) {
	if(Trigger.isAfter){
        
        //Increments total number of contacts field in Account obj when a related contact is inserted.
        if(Trigger.isInsert){
            ContactTriggerHandler.addNumOfContactsForInsertUndeleteOp(Trigger.New);
        }
        
        //Decrements total number of contacts field in Account obj when a related contact is deleted.
        if(Trigger.isDelete){
            ContactTriggerHandler.deleteNumOfContactsForDeleteOp(Trigger.old);
        }
        
        //Increments total number of contacts field in Account obj when a related contact is undeleted.
        if(Trigger.isUndelete){
            ContactTriggerHandler.addNumOfContactsForInsertUndeleteOp(Trigger.New);
        }
    }
}