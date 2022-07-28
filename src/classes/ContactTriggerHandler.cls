/*
* 	Description		:	To update total number of contacts whenever an account is inserted, deleted or undeleted
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	26/07/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/07/2022 (Used Incrementation/Decrementation to
*                                                                 calculate num of related contacts)
*                       V_1.1 -Modified By - Soumi Chakraborty - 26/07/2022 (Used AggregateResult to calculate 
*                                                                num of related contacts instead of incrementation/decrementation)
* 
* */
public class ContactTriggerHandler {

    /*
    *
    *   Purpose :   Feteches the Account IDs of the contacts that are inserted or undeleted and then uses this IDs to
    * 				populate the total number of contacts field in Account obj when a related contact is inserted or undeleted or deleted.
    *
    */
    public static void populateNumOfContactsOnAccount(List<Contact> contactListNew,List<Contact> contactListOld){
        Set<Id> setOfAccIds=new Set<Id>();
        for(Contact con : contactListNew != null ? contactListNew : contactListOld){
            setOfAccIds.add(con.AccountId);
        }
        List<AggregateResult> groupedResult =[SELECT AccountId, COUNT(Id) totConts FROM Contact WHERE AccountId IN: setOfAccIds
                                                GROUP BY AccountId];
        Set<Id> IdOfContsFromResult = new  Set<Id>();      //This Id set excludes those ACC Ids that have no related contact                                   
        Set<Account> setOfAccToUpdate = new Set<Account>();
        List<Account> listOfAccToUpdate = new List<Account>();
        List<Account> accountsList =[SELECT Id, Name FROM Account WHERE Id IN: setOfAccIds];                                                                            
        for(AggregateResult result: groupedResult){
            IdOfContsFromResult.add((Id)result.get('AccountId'));
            for(Account ac : accountsList){
                if(ac.Id==(Id)result.get('AccountId')){
                    ac.Num_of_Contacts__c=(Integer)result.get('totConts');
                    setOfAccToUpdate.add(ac);
                    System.debug('Account -> '+ac.Name+' has -> '+ac.Num_of_Contacts__c+' related Contacts');
                }
            }
        }
        //This list contains those Account Ids that dont have any related contact
        //We made this list seperately as Aggregate result could not count 0 for no related contacts.
        List<Account> acList=[SELECT Id FROM Account WHERE (Id IN: setOfAccIds AND Id NOT IN: IdOfContsFromResult)];
        for(Account ac: acList){
            ac.Num_of_Contacts__c=0;         //No related contacts
            setOfAccToUpdate.add(ac);
        }
        listOfAccToUpdate.addAll(setOfAccToUpdate);
        update listOfAccToUpdate;
    }
}