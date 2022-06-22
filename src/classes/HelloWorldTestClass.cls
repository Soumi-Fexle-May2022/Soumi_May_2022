/*
 * 	Description		:	This test class is used for verifying code coverage of MyHelloWorld class and HelloWolrdTrigger
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	21/05/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 21/05/2022
 **/
@isTest 
private class HelloWorldTestClass {
    static testMethod void validateHelloWorld() {
       Book__c b = new Book__c(Name='Behind the Cloud', Price__c=100);
       System.debug('Price before inserting new book: ' + b.Price__c);

       // Insert book
       insert b;
    
       // Retrieve the new book
       b = [SELECT Price__c FROM Book__c WHERE Id =:b.Id];
       System.debug('Price after trigger fired: ' + b.Price__c);

       // Test that the trigger correctly updated the price
       System.assertEquals(90, b.Price__c);
    }
}