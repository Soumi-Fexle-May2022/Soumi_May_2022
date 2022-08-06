/*
* 	Description		:	To insert, update related records for Opportunity under its 4 child objects, and to send email to owner.
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	29/07/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 29/07/2022 
* 
* */
trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            OpportunityTriggerHelper.populateChildObjRecords(Trigger.new, Trigger.old);
        }
    }
}