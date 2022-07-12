/*
 * 	Description		:	To understand DML insertions,updations e.t.c.
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	08/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 08/07/2022
 * */
public class DML_LearningController {

    /*
    *
    *   Purpose :   To execute DML updation with minimal statements by using lists.
    *
    */
    public static void bulkDML(){
        // List to hold the new contacts to update.
        List<Contact> updatedList = new List<Contact>();
        List<Contact> conList = [Select Name, Department , Description from Contact];
        for(Contact con : conList) {
            if (con.Department == 'Finance') {
                con.Description = 'New description';
                // Add updated contact sObject to the list.
                updatedList.add(con);
            }
        }

        // Call update on the list of contacts.
        // This results in one DML call for the entire list.
        System.debug(updatedList);
        update updatedList;
    }

    /*
    *
    *   Purpose :   To add records, update and then retrieve certain fields from the record.
    *
    */
    public static void addRetrieveData(){
        Account a = new Account(Name='Account Example');
        insert a;
        // Query existing account.
        a = [SELECT Name,Industry 
        FROM Account 
        WHERE Name='Account Example' LIMIT 1];

        // Write the old values the debug log before updating them.
        System.debug('Account Name before update: ' + a.Name); // Name is Account Example
        System.debug('Account Industry before update: ' + a.Industry);// Industry is not set

        // Modify the two fields on the sObject.
        a.Name = 'Account of the Day';
        a.Industry = 'Technology';

        // Persist the changes.
        update a;

        // Get a new copy of the account from the database with the two fields.
        a = [SELECT Name,Industry 
        FROM Account 
        WHERE Name='Account of the Day' LIMIT 1];

        System.debug('Account Name after update: ' + a.Name);
        System.debug('Account Industry after update: ' + a.Industry);

        // Verify that updated field values were persisted.
        System.assertEquals('Account of the Day', a.Name);
        System.assertEquals('Technology', a.Industry);
    }

    /*
    *
    *   Purpose :   To insert a list of Account records and update one of them and then assertain if it has corrrectly updated
    *
    */
    public static void insertUpdateRecord(){
        Account[] accts = new List<Account>();
        for(Integer i=0;i<3;i++) {
            Account a = new Account(Name='Acme' + i, 
                                    BillingCity='San Francisco');
            accts.add(a);
        }
        Account accountToUpdate;
        try {
            insert accts;        
            
            // Update account Acme2.
            accountToUpdate = 
                [SELECT BillingCity FROM Account 
                WHERE Name='Acme2' AND BillingCity='San Francisco'
                LIMIT 1];
            // Update the billing city.
            accountToUpdate.BillingCity = 'New York';
            // Make the update call.
            update accountToUpdate;
            System.debug('We have updated:-');
            System.debug(accountToUpdate);
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }

        // Verify that the billing city was updated to New York.
        Account afterUpdate = 
            [SELECT BillingCity FROM Account WHERE Id=:accountToUpdate.Id];
        System.assertEquals('New York', afterUpdate.BillingCity);
    }

    /*
    *
    *   Purpose :   Creates an account record. Links this account record with a contact record by passing account id to the field in the contact.
    *
    */
    public static void insertRelatedRecord(){
        try {
            Account acct = new Account(Name='SFDC Account');
            insert acct;
        
            // Once the account is inserted, the sObject will be 
            // populated with an ID.
            // Get this ID.
            ID acctID = acct.ID;
        
            // Add a contact to this account.
            Contact con = new Contact(
                FirstName='Joe',
                LastName='Smith',
                Phone='415.555.1212',
                AccountId=acctID);
            insert con;
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    /*
    *
    *   Purpose :   To update a contact record and also to update the technology field of the account that is lined with that contact
    *               (Verification of the changed field from that account record can be seen from the accounts record detail page)
    *
    */
    public static void updateRelatedRecord(){
        try {
            // Query for the contact, which has been associated with an account.
            Contact queriedContact = [SELECT Account.Name 
                                      FROM Contact 
                                      WHERE FirstName = 'Joe' AND LastName='Smith'
                                      LIMIT 1];
        
            // Update the contact's phone number
            queriedContact.Phone = '415.555.1213';
        
            // Update the related account industry
            queriedContact.Account.Industry = 'Technology';
        
            // Make two separate calls 
            // 1. This call is to update the contact's phone.
            update queriedContact;
            // 2. This call is to update the related account's Industry field.
            update queriedContact.Account; 
        } catch(Exception e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }

    /*
    *
    *   Purpose :   To link an existing account record to a newly created opportunity using external id field of that account record.
    *
    */
    public static void relatingRecordsByExtID(){
        Opportunity newOpportunity = new Opportunity(
        Name='OpportunityWithAccountInsert',
        StageName='Prospecting',
        CloseDate=Date.today().addDays(7));

        // Create the parent record reference.
        // An account with external ID = 'SAP111111' already exists.
        // This sObject is used only for foreign key reference
        // and doesn't contain any other fields.
        Account accountReference = new Account(
            MyExtID__c='SAP111111');                

        // Add the account sObject to the opportunity.
        newOpportunity.Account = accountReference;

        // Create the opportunity.
        Database.SaveResult results = Database.insert(newOpportunity);
    }

    /*
    *
    *   Purpose :   To insert an account record with external id and to link the opportunity with that account
    *               and to diplay its insertion status.
    *
    */
    public static void insertParentChild() {
        Date dt = Date.today();
        dt = dt.addDays(7);
        Opportunity newOpportunity = new Opportunity(
            Name='OpportunityWithAccountInsert',
            StageName='Prospecting',
            CloseDate=dt);
        
        // Create the parent reference.
        // Used only for foreign key reference
        // and doesn't contain any other fields.
        Account accountReference = new Account(
            MyExtID__c='SAP111111');                
        newOpportunity.Account = accountReference;
        
        // Create the Account object to insert.
        // Same as above but has Name field.
        // Used for the insert.
        Account parentAccount = new Account(
            Name='Hallie',
            MyExtID__c='SAP111111');      
        
        // Create the account and the opportunity.
        Database.SaveResult[] results = Database.insert(new SObject[] {
            parentAccount, newOpportunity });
        
        // Check results.
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
            System.debug('Successfully created ID: '
                  + results[i].getId());
            } else {
            System.debug('Error: could not create sobject '
                  + 'for array element ' + i + '.');
            System.debug('   The error reported was: '
                  + results[i].getErrors()[0].getMessage() + '\n');
            }
        }
    }
}