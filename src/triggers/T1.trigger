/*
 * 	Description		:	To understand how to use Static variable in a trigger without refreshing it
 *                      eacg time a trigger fires.
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/06/2022
 * */
trigger T1 on Account (before delete, after delete, after undelete) { 
    if(Trigger.isBefore){
       if(Trigger.isDelete){
          if(p.firstRun){
              Trigger.old[0].addError('Before Account Delete Error');
               p.firstRun=false;
           } 
        }
     }
}