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
    public static Boolean isTriggerRan = false;

    /*
    *
    *   Purpose :   Puts Parent Account status into child contact status if child contact status is empty
    *               and puts Grandparent Property status into child contact status if child contact status and parent account status is empty
    *
    */
    public static void syncContactWithRelatedAccountAndProperty(List<Contact> contactListNew,List<Contact> contactListOld){
        Set<Id> setOfAccountIds = new Set<Id>();
        for(Contact con : contactListNew){
            if(con.Status__c == null){
                setOfAccountIds.add(con.AccountId);
            }
        }
        Map<id,Account> accMap = new Map<id,Account>();
        accMap.putAll([SELECT Id, Status__c,Property__c FROM Account WHERE Id IN: setOfAccountIds]);

        Map<id,Property__c> propMap = new Map<id,Property__c>();
        propMap.putAll([SELECT Id, Status__c FROM Property__c ]);

        for(Contact con : contactListNew){
            if(con.Status__c == null){
                Account acc = accMap.get(con.AccountId);
                if(acc.Status__c != null){
                    con.Status__c = acc.Status__c;
                }
                else{
                    Property__c prop=propMap.get(acc.Property__c);
                    if(prop.Status__c != null){
                        con.Status__c = prop.Status__c;
                    }
                }
            }
        }
    }

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
        //Adding those Acc Ids which were in a contact record before an update
        //So that we can update the fields of the old Parent Account of a Contact after an update
        if(contactListOld !=null){
            for(Contact con : contactListOld){
                setOfAccIds.add(con.AccountId);
            }
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
        if(listOfAccToUpdate.size()>0){
            update listOfAccToUpdate;
        }
    }

    /*
    *
    *   Purpose :   Creates duplicate contacts for each user inserted contact from UI or anonymous window.
    *               Main purpose is to check recursive triggers and way to stop it.
    *
    */
    /*public static void createDuplicateContact(List<Contact> newConList){
        List<Contact> dupContactsToInsert= new List<Contact>();
        for(Contact con: newConList){
            Contact con1 = new Contact();
            con1.LastName='Dupicate Contact';
            dupContactsToInsert.add(con1);
        }
        insert dupContactsToInsert;
    }*/
}