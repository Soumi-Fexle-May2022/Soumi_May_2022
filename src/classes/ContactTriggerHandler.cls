/*
 * 	Description		:	To update total number of contacts whenever an account is inserted, deleted or undeleted
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/07/2022
 * 
 * */
public class ContactTriggerHandler {
    
    /*
    *
    *   Purpose :   Feteches the Account IDs of the contacts that are inserted or undeleted and then uses this IDs to
    * 				increment total number of contacts field in Account obj when a related contact is inserted or undeleted.
    *
    */
    public static void addNumOfContactsForInsertUndeleteOP(List<Contact> contactList){
        List<Id> accId=new List<Id>();
         for(Contact con : contactList){
         	accId.add(con.AccountId);
         }
         List<Account> accList =[SELECT Id,Num_of_Contacts__c FROM Account WHERE Id IN: accId];
         Set<Account> setOfAccnts = new Set<Account>();
         List<Account> accToUpdate = new List<Account>();
         for(Account acc :accList){
             if(acc.Num_of_Contacts__c==Null){
                acc.Num_of_Contacts__c=0;		//Changing Null values to 0 of fields to avoid exceptions while incrementation.
             }
             acc.Num_of_Contacts__c+=1;
             setOfAccnts.add(acc);
         }
         accToUpdate.addAll(setOfAccnts);
         update accToUpdate;
    }
    
    /*
    *
    *   Purpose :   Feteches the Account IDs of the contacts that are deleted and then uses this IDs to
    * 				decrement total number of contacts field in Account obj when a related contact is deleted.
    *
    */
    public static void deleteNumOfContactsForDeleteOp(List<Contact> contactList){
        List<Id> accId=new List<Id>();
        for(Contact con : contactList){
        	accId.add(con.AccountId);
        }
        List<Account> accList =[SELECT Id,Num_of_Contacts__c FROM Account WHERE Id IN: accId];
        Set<Account> setOfAccnts = new Set<Account>();
        List<Account> accToUpdate = new List<Account>();
        for(Account acc :accList){
        	acc.Num_of_Contacts__c-=1;
            setOfAccnts.add(acc);
        }
        accToUpdate.addAll(setOfAccnts);
        update accToUpdate;
    }
}