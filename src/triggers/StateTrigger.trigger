/*
 * 	Description		:	This trigger updates total states field, total districts field and Country Json Data field in Country object
 *                      when any state is inserted , updated , deleted or undeleted
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	08/08/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 08/08/2022
 * 
 * */
trigger StateTrigger on State__c (after insert,after update,after delete, after undelete) {
	if(Trigger.isAfter){
        if(Trigger.isInsert ||Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete){
            StateTriggerHelper.populateNumOfStatesOnCountry(Trigger.New,Trigger.old);
        }
    }
}