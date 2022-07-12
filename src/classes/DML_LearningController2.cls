/*
 * 	Description		:	To understand DML upserting, delete and undelete operations
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	10/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 10/07/2022
 * */
public class DML_LearningController2 {

    /*
    *
    *   Purpose :   To execute upserting on Account records- changes are made to an account record and saved to list also new account record 
    *               is created and added to that list and lastly the list is upserted.
    *
    */
    public static void upserting() {
        Account[] acctsList = [SELECT Id, Name, BillingCity
                        FROM Account WHERE BillingCity = 'Bombay'];
        for (Account a : acctsList) {
            a.BillingCity = 'Mumbai';
        }
        Account newAcct = new Account(Name = 'Acme', BillingCity = 'San Francisco');
        acctsList.add(newAcct);
        System.debug('We are upsering:-');
        System.debug(acctsList);
        try {
            upsert acctsList;
        } catch (DmlException e) {
            System.debug('Error'+e.getMessage());
        }
    }        

    /*
    *
    *   Purpose :   To delete certain Account records
    *
    */
    public static void deleteRecords(){
        Account[] doomedAccts = [SELECT Id, Name FROM Account 
                         WHERE Name = 'Acme0' OR Name = 'Acme1' OR Name = 'Acme2']; 
        try {
            delete doomedAccts;
        } catch (DmlException e) {
            System.debug('Error'+e.getMessage());
        }
    }

    /*
    *
    *   Purpose :   To undelete certain account records (to restore from recycle bin)
    *
    */
    public static void undeleteRecords(){
        Account[] savedAccts = [SELECT Id, Name FROM Account 
        WHERE Name = 'Acme0' OR Name = 'Acme1' OR Name = 'Acme2' ALL ROWS]; 
        try {
            undelete savedAccts;
        } catch (DmlException e) {
            System.debug('Error'+e.getMessage());
        }
    }
}