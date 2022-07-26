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
    public static void deleteRelatedOpps(List<Account> accList){
        Set<Id> setOfAccIDs = new Set<Id>();
        for(Account acc: accList){
            setOfAccIDs.add(acc.Id);
        }
        List<Opportunity> oppsListToDelete =[SELECT AccountId FROM Opportunity WHERE AccountId IN: setOfAccIDs];
        delete oppsListToDelete;
    }
}