/*
 * 	Description		:	To fetch first name,last name, title of all contacts
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	09/09/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 09/09/2022
 * */
public with sharing class ContactController {
    @AuraEnabled(Cacheable = true)
    public static List<Contact> getContactList() {
        List<Contact> contactList =[SELECT Id,FirstName, LastName, Title FROM Contact];
        return contactList;
    }
}