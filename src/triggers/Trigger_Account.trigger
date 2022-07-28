/*
 * 	Description		:	To understand trigger context variables w.r.t trigger events. And
 *                      This trigger fires whenever an account is updated, it then deletes its related opportunities.
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	20/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 20/07/2022
 *                      V_1.1 - Modified By - Soumi Chakraborty - 26/07/2022 (Added After Update trigger event to delete related
 *                                                                            opportunities of updated Account records)
 * */
trigger Trigger_Account on Account (before insert, before update,before delete, after insert, after update,after delete,after undelete) {
    
    if(Trigger.isBefore){
        System.debug('Checking in Before Trigger Operations');
        //Before Insert Trigger
        if(Trigger.isInsert){
            System.debug('-------------------------------------------');
            System.debug('Insert List ::: Trigger.New ' + Trigger.new);
            System.debug('Insert List ::: Trigger.old ' + Trigger.old);

            for(Account accRecNew: Trigger.new){
                System.debug('Account -> '+accRecNew.Name+' has been inserted');
            }

        }
        //Before Update Trigger
        if(Trigger.isUpdate){
            System.debug('-------------------------------------------');            
            System.debug('Update List ::: Trigger.New ' + Trigger.new);
            System.debug('Update List ::: Trigger.old ' + Trigger.old);
            
            /* Not Bulkified
            if(Trigger.New[0].Type != Trigger.old[0].Type){
                
                System.debug('**Type Value Changed**');
                System.debug('Trigger.New has now type ' + Trigger.new[0].Type);
                System.debug('Trigger.old had then type ' + Trigger.old[0].Type);
            }*/

            //Bulifying 
            for(Account accRecNew: Trigger.new){
                Account accRecOld = Trigger.oldMap.get(accRecNew.Id);
                if(accRecNew.Type!= accRecOld.Type){
                    System.debug('***Type Value Changed***');
                    System.debug('For account '+accRecNew.Name+' ,type changed from '+accRecOld.Type+' to '+accRecNew.Type);
                }
                /*else{
                    accRecNew.Type.addError('Custom trigger validation: Type must be changed');
                }*/
            }
        }
        if(Trigger.isDelete){
            System.debug('-------------------------------------------');            
            System.debug('Delete List ::: Trigger.New ' + Trigger.new);
            System.debug('Delete List ::: Trigger.old ' + Trigger.old);
        }
    }
    
    if(Trigger.isAfter){    
        System.debug('Checking in After Trigger Operations');
        if(Trigger.isInsert){
            System.debug('-------------------------------------------');
            System.debug('Insert List ::: Trigger.New ' + Trigger.new);
            System.debug('Insert List ::: Trigger.old ' + Trigger.old);
        }
        if(Trigger.isUpdate){
            System.debug('-------------------------------------------');            
            System.debug('Update List ::: Trigger.New ' + Trigger.new);
            System.debug('Update List ::: Trigger.old ' + Trigger.old);

            //Deletes related opportunities of an updated account
            AccountTriggerHandler.deleteAccountRelatedOpps(Trigger.old, Trigger.oldMap);
        }
        if(Trigger.isDelete){
            System.debug('-------------------------------------------');            
            System.debug('Delete List ::: Trigger.New ' + Trigger.new);
            System.debug('Delete List ::: Trigger.old ' + Trigger.old);
        }
        if(Trigger.isUndelete){
            System.debug('-------------------------------------------');            
            System.debug('Undelete List ::: Trigger.New ' + Trigger.new);
            System.debug('Undelete List ::: Trigger.old ' + Trigger.old);
        }
    }
}