/*
 * 	Description		:	This trigger updates total districts and State Json Data field in State object ;and updates total districts field 
 *                      and Country Json Data field in Country Object when any district is inserted ,updated , deleted or undeleted
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	08/08/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 08/08/2022
 * 
 * */
trigger DistrictTrigger on District__c (after insert,after update,after delete, after undelete) {
	if(Trigger.isAfter){
        if(Trigger.isInsert ||Trigger.isUpdate || Trigger.isDelete || Trigger.isUndelete){
            DistrictTriggerHelper.populateNumOfDistrictsOnStateAndCountry(Trigger.New,Trigger.old);
        }
    }
}