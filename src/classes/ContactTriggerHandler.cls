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
    public static void populateNumOfContactsOnAccount(List<Contact> contactListNew,List<Contact> contactListOld){
        
        /*
        *
        *   Purpose :   Feteches the Account IDs of the contacts that are inserted or undeleted and then uses this IDs to
        * 				increment total number of contacts field in Account obj when a related contact is inserted or undeleted.
        *
        */
        if(contactListOld == Null){
            List<Id> accIdsNew=new List<Id>();
            for(Contact con : contactListNew){
                accIdsNew.add(con.AccountId);
            }
            List<Account> accList =[SELECT Id,Num_of_Contacts__c FROM Account WHERE Id IN: accIdsNew];
            Set<Account> setOfAccntsNew = new Set<Account>();
            List<Account> accToUpdateNew = new List<Account>();
            for(Account acc :accList){
                if(acc.Num_of_Contacts__c==Null){
                    acc.Num_of_Contacts__c=0;		//Changing Null values to 0 of fields to avoid exceptions while incrementation.
                }
                acc.Num_of_Contacts__c+=1;
                setOfAccntsNew.add(acc);
            }
            accToUpdateNew.addAll(setOfAccntsNew);
            update accToUpdateNew;
        }

        /*
        *
        *   Purpose :   Feteches the Account IDs of the contacts that are deleted and then uses this IDs to
        * 				decrement total number of contacts field in Account obj when a related contact is deleted.
        *
        */
        else if(contactListOld != Null){
            List<Id> accIdsOld=new List<Id>();
            for(Contact con : contactListOld){
                accIdsOld.add(con.AccountId);
            }
            List<Account> accList =[SELECT Id,Num_of_Contacts__c FROM Account WHERE Id IN: accIdsOld];
            Set<Account> setOfAccntsOld = new Set<Account>();
            List<Account> accToUpdateOld = new List<Account>();
            for(Account acc :accList){
                acc.Num_of_Contacts__c-=1;
                setOfAccntsOld.add(acc);
            }
            accToUpdateOld.addAll(setOfAccntsOld);
            update accToUpdateOld;
        }
    }
}