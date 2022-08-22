/*
* 	Description		:	To update all account records owner to another user 
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	18/08/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 18/08/2022 
* 
* */
public class OwnerReassignment implements Database.Batchable<sObject>{
    public final String query;
    public final String email;
    public final Id toUserId;
    public final Id fromUserId;
    
    public Database.querylocator start(Database.BatchableContext BC){
                return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account> accns = new List<Account>();
    
       for(sObject s : scope){Account a = (Account)s;
            if(a.OwnerId==fromUserId){
                a.OwnerId=toUserId;
                accns.add(a);
                }
            }
    
    update accns;
        
    }
    public void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('batch@acme.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}