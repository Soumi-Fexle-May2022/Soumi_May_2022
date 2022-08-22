/*
* 	Description		:	This example is an implementation of the Queueable interface. 
*                       The execute method in this example inserts a new account.
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	21/08/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 21/08/2022 
* 
* */
public class AsyncExecutionExample implements Queueable {
    public void execute(QueueableContext context) {
        Account a = new Account(Name='Acme',Phone='(415) 555-1212');
        insert a;        
    }
}