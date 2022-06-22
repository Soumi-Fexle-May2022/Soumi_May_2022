/*
 * 	Description		:	The method inside the class updates the book price
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	21/05/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 21/05/2022
 **/
public class MyHelloWorld {
    public static void applyDiscount(Book__c[] books) {
        for (Book__c b :books){
          b.Price__c *= 0.9;
       }
    }
}