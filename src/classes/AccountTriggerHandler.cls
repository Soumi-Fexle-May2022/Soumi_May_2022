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
    *   Purpose :   To verify if before trigger modifies value without the need of DML
    *
    */
        public static void performDMlForBeforeEventOnNew(List<Account> accListNew){
        //List<Account> accToUpdate=new List<Account>();
        for(Account accNew: accListNew){
            if (accNew.Type=='Prospect'){
                System.debug('Type before Updation using trigger-->'+accNew.Type);
                accNew.Type='Customer - Direct';
                System.debug('Type before Updation using trigger-->'+accNew.Type);
                //accToUpdate.add(accNew);     //This is Wrong approach
            }
        }
        //update accToUpdate;    //DML Not allowed in case of Before Event
    }
    /*
    *
    *   Purpose :   To verify if before trigger modifies value without the need of DML and also to verify if Trigger.old
    *               cannot be modified
    *
    */
    public static void performDMlForBeforeEventonNewAndOld(List<Account> accListNew,List<Account> accListOld){
        System.debug('Updating Trigger.new from before update--');
        for(Account accNew: accListNew){
            if (accNew.Type=='Prospect'){
                System.debug('Type before Updation using trigger-->'+accNew.Type);
                accNew.Type='Customer - Direct';
                System.debug('Type before Updation using trigger-->'+accNew.Type);
            }
        }
        //Old values are read only and cannot be modified.
        //List<Account> accToUpdate=new List<Account>();
        /*System.debug('Updating Trigger.old from before update--');
        for(Account accOld: accListOld){
            if (accOld.Type=='Prospect'){
                System.debug('Type before Updation using trigger-->'+accOld.Type);
                accOld.Type='Customer - Direct';
                System.debug('Type before Updation using trigger-->'+accOld.Type);
                //accToUpdate.add(accOld);     //This is Wrong approach
            }
        }*/
        //update accToUpdate;    //DML Not allowed in case of Before Event
    }
    /*
    *
    *   Purpose :   To create custom validation using trigger to enter a proper phone number
    *
    */
    public static void validatePhoneNumField(List<Account> accListNew){
        String phNum;
        for(Account accNew : accListNew){
            if(accNew.Phone!=null){
                phNum=accNew.Phone;
                if(!phNum.isNumeric() || phNum.length()>10){
                    accNew.Phone.addError('Trigger generated custom validation: Enter correct Phone Number');
                }
        	}
        }
    }
    /*
    *
    *   Purpose :   To see if before trigger can update a field value according to the value of the related Onject
    *
    */
    public static void populateTypeAccToRelatedOppAmount(List<Account> accListNew){
        List<Opportunity> relatedOppsList =[SELECT AccountId,Name,Amount FROM Opportunity WHERE AccountId IN: accListNew];
        Set<Id> accIds = new Set<Id>();
        for(Opportunity relatedOpp : relatedOppsList){
            if(relatedOpp.Amount>=100000000){
                accIds.add(relatedOpp.AccountId);
            }
        }
        for(Account acc : accListNew){
            if(accIds.contains(acc.Id)){
                acc.Type='Strategic Account';
            }
        }
    }
    /*
    *
    *   Purpose :   To populate Account type according to the entered Annual Revenue field 
    *
    */
    public static void populateTypeAccToRevenue(List<Account> accListNew){
        for(Account acc : accListNew){
            if (acc.AnnualRevenue>=100000000){
                acc.Type='Strategic Account';
            }
            else if(acc.AnnualRevenue>10000000 && acc.AnnualRevenue<100000000){
                acc.Type='Growth Account';
            }
            else{
                acc.Type='New Comer Account';
            }
        }
    }
    /*
    *
    *   Purpose :   To populate Discount field according to the entered Annual Revenue field 
    *
    */
    public static void populateDiscountAccToRevenue(List<Account> accListNew,List<Account> accListOld){
        //We are checking if field is updated by not using Trigger.oldMap but by Trigger.old
        Integer count=0;
        for(Account acc: accListNew){
            if(acc.AnnualRevenue!=accListOld[count].AnnualRevenue && acc.AnnualRevenue>=100000000){
                acc.Discount__c=50;
            }
            count++;
        }
    }
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

    /*
    *
    *   Purpose :   To let the user know if the Account type has been updated in debug logs and commented out the code to 
    *               set a custom validation of making a change in Account type as must 
    *
    */
    public static void generateCustomValidationUsingTrigger(List<Account> accNewList, Map<Id,Account> accOldMap){
        for(Account accRecNew: accNewList){
            Account accRecOld = accOldMap.get(accRecNew.Id);
            if(accRecNew.Type!= accRecOld.Type){
                System.debug('***Type Value Changed***');
                System.debug('For account '+accRecNew.Name+' ,type changed from '+accRecOld.Type+' to '+accRecNew.Type);
            }
            /*else{
                accRecNew.Type.addError('Custom trigger validation: Type must be changed');
            }*/
        }
    }
    
    /*
    *
    *   Purpose :   To verify if after trigger doesn't modify field value with or without DML and to verify that
    *               Trigger.newis read only
    *
    */
    public static void performDMlForAfterEvent(List<Account> accListNew){
        //List<Account> accToUpdate=new List<Account>();
        /*for(Account accNew: accListNew){            
            if (accNew.Type=='Installation Partner'){
                System.debug('Before-->'+accNew.Type);
                accNew.Type='Technology Partner';  //This is not allowed
                //accToUpdate.add(accNew);  //This is also not allowed as after event is readOnly
            }
        }*/
        //update accToUpdate; //Not allowed as after event is readOnly*/
    }

    /*
    *
    *   Purpose :   To verify if after trigger doesn't modify field value with or without DML  and to verify that
    *               Trigger.new and Trigger.old is read only
    *
    */
    public static void performDMlForAfterEventonNewAndOld(List<Account> accListNew,List<Account> accListOld){
        /*System.debug('Updating Trigger.new from before update--');
        for(Account accNew: accListNew){
            if (accNew.Type=='Customer - Channel'){
                System.debug('Type before Updation using trigger-->'+accNew.Type);
                accNew.Type='Technology Partner';
                System.debug('Type before Updation using trigger-->'+accNew.Type);
            }
        }*/
        //Old values are read only and cannot be modified.
        //List<Account> accToUpdate=new List<Account>();
        /*System.debug('Updating Trigger.old from before update--');
        for(Account accOld: accListOld){
            if (accOld.Type=='Customer - Channel'){
                System.debug('Type before Updation using trigger-->'+accOld.Type);
                accOld.Type='Technology Partner';
                System.debug('Type before Updation using trigger-->'+accOld.Type);
                //accToUpdate.add(accOld);     //This is Wrong approach
            }
        }*/
        //update accToUpdate;    //DML Not allowed in case of Before Event
    }
}