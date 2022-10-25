/*
 * 	Description		:	To schedule a asynchronous batch apex class to send monthly transaction details to active contacts
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	08/10/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 08/10/2022
 * */
public with sharing class EmailNotificationScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        
        Database.executeBatch(new EmailNotificationBatchClass());
    }
}