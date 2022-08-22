/*
* 	Description		:	The useFutureMethod method in MixedDMLFuture inserts an account and calls the future method, insertUserWithRole. 
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	20/08/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 20/08/2022 
* 
* */
public class MixedDMLFuture {
    public static void useFutureMethod() {
        // First DML operation
        Account a = new Account(Name='Acme');
        insert a;
        
        // This next operation (insert a user with a role) 
        // can't be mixed with the previous insert unless 
        // it is within a future method. 
        // Call future method to insert a user with a role.
        Util.insertUserWithRole(
            'mruiz@awcomputing.com', 'mruiz', 
            'mruiz@awcomputing.com', 'Ruiz');        
    }
}