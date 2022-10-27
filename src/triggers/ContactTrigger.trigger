/*
 * 	Description		:	This trigger fires i)and puts Parent Account status into child contact status if child contact status is empty
 *                      and puts Grandparent Property status into child contact status if child contact status and parent account status
 *                      is empty whenever a child contact is created.
 *                      ii)whenever an contact related to an account is added or removed, and changes the 
 * 						total number of contacts field in that Account accordingly
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/07/2022
 * 
 * */
trigger ContactTrigger on Contact (before insert,before update,after insert,after update,after delete, after undelete) {
    if(Trigger.isBefore){
        if(Trigger.isInsert ||Trigger.isUpdate){
            ContactTriggerHandler.syncContactWithRelatedAccountAndPropertyAndCheckAvailableBaln(Trigger.New,Trigger.old);
        }
    }
	else if(Trigger.isAfter){
        if(Trigger.isInsert ||Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete){
            /*Recursive trigger example-
            if(Trigger.isInsert && !ContactTriggerHandler.isTriggerRan){
                ContactTriggerHandler.isTriggerRan= true;
                ContactTriggerHandler.createDuplicateContact(Trigger.New);
            }*/
            ContactTriggerHandler.populateNumOfContactsOnAccount(Trigger.New,Trigger.old);
        }
    }
}