/*
 * 	Description		:	To understand constructor chaining using this keyword
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	29/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 29/06/2022
 * */
public class testThis {
    // First constructor for the class. It requires a string parameter.
       public testThis(string s2) {
        System.debug('Passed : '+s2+', using this keyword');
       }
    
    // Second constructor for the class. It does not require a parameter.
    // This constructor calls the first constructor using the this keyword.
       public testThis() {
           this('None');
       }
}