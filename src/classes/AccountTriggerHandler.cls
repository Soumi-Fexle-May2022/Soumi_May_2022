/*
 * 	Description		:	To delete the Opportunites related to an updated Account
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/07/2022
 * 
 * */
public class AccountTriggerHandler {
    
    /*
    *
    *   Purpose :   Feteches the IDs of those accounts that are updated and then uses those IDs to delete the related 
    * 				opportunities of those updated accounts
    *
    */
    public static void deleteAccountRelatedOpps(List<Account> accOldList, Map<Id,Account> accOldMap){
        Set<Id> setOfAccIDs = new Set<Id>();
        for(Account acc: accOldList != null ? accOldList : accOldMap.values()){
            setOfAccIDs.add(acc.Id);
        }
        //setOfAccIDs is never null because it receives value from Trigger.old which activated due to after update trigger
        List<Opportunity> oppsListToDelete =[SELECT AccountId FROM Opportunity WHERE AccountId IN: setOfAccIDs];
        if(oppsListToDelete.size()>0){
            delete oppsListToDelete;
        }
    }
}