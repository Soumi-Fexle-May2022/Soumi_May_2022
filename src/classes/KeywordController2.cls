/*
 * 	Description		:	To understand instanceOf keyword while passing Object type during runtime
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	04/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 04/07/2022
 * */
public class KeywordController2 {
    public static SObject s ;
    public KeywordController2(){        
        if(s instanceOf Account ){
            Account a =(Account)s;
            System.debug('It is an Account object');
            a.Name = 'Adamas University Account';
            a.AccountNumber = '12345678';
            insert a;
            System.debug('One account created!');
            Account acc= new Account(Name='Calcutta University Account', AccountNumber='98765432', Phone='3457');
            insert acc;
            System.debug('Another account created!');
            SObject sobj= new Account();
            sobj.put('Name','Soumis Account');
            sobj.put('AccountNumber','555555');
            insert sobj;
            System.debug('Another account created!');
        }
        else if(s instanceOf Contact){
            Contact c =(Contact)s;
            System.debug('It is an Contact object');
        }
        else if(s instanceOf Lead){
            Lead c =(Lead)s;
            System.debug('It is an Lead object');
        }
    }
}