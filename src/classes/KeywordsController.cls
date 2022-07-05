/*
 * 	Description		:	To understand instanceOf keyword
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	29/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 29/06/2022
 * */
public class KeywordsController {
    public KeywordsController() {
        SObject s = new Contact();
        if(s instanceOf Account ){
            Account a =(Account)s;
            System.debug('It is an Account object');
        }
        else if(s instanceOf Contact){
            Contact c =(Contact)s;
            System.debug('It is an Contact object');
        }
    }
}