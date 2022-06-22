/*
 * 	Description		:	This trigger calls the method that updates the book price from MyHelloWorld class
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	21/05/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 21/05/2022
 **/
trigger HelloWorldTrigger on Book__c (before insert) {

   Book__c[] books = Trigger.new;

   MyHelloWorld.applyDiscount(books);
}