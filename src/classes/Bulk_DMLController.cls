/*
 * 	Description		:	To understand DML updations and how to improve code by decreasing number of DML statements
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	10/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 10/07/2022
 * */
public with sharing class Bulk_DMLController {

    /*
    *
    *   Purpose :   Stores all contacts in a list and updates selected contacts one by one
    *
    */
    public static void updating_level0() {
        List<Contact> conList = [Select Department , Description from Contact];
        for(Contact badCon : conList) {
            if (badCon.Department == 'Finance') {
                badCon.Description = 'New description 1';
            }
        // Not a good practice since governor limits might be hit.
        update badCon;
        }
    }

    /*
    *
    *   Purpose :   Stores all contacts in a list and stores changed contacts in another list and updates the list at last
    *
    */
    public static void updating_level1(){
        // List to hold the new contacts to update.
        List<Contact> updatedList = new List<Contact>();
        List<Contact> conList = [Select Department , Description from Contact];
        for(Contact con : conList) {
            if (con.Department == 'Finance') {
                con.Description = 'New description';
                // Add updated contact sObject to the list.
                updatedList.add(con);
            }
        }

        // Call update on the list of contacts.
        // This results in one DML call for the entire list.
        update updatedList;
    }

    /*
    *
    *   Purpose :   Queries to select all contacts inside the loop itself and stores changed 
    *                contacts in another list and updates the list at last
    *
    */
    public static void updating_level2(){
        // List to hold the new contacts to update.
        List<Contact> updatedList = new List<Contact>();
        for(Contact con : [Select Department , Description from Contact]) {
            if (con.Department == 'Finance') {
                con.Description = 'New description 2';
                // Add updated contact sObject to the list.
                updatedList.add(con);
            }
        }

        // Call update on the list of contacts.
        // This results in one DML call for the entire list.
        update updatedList;
    }

    /*
    *
    *   Purpose :   Queries to select only those contacts that needs to be updated inside the loop itself and stores changed 
    *                contacts in another list and updates the list at last
    *
    */
    public static void updating_level3(){
        // List to hold the new contacts to update.
        List<Contact> updatedList = new List<Contact>();
        for(Contact con : [Select Department , Description from Contact Where Department = 'Finance']) {            
            con.Description = 'New description 3';
            // Add updated contact sObject to the list.
            updatedList.add(con);
        }
        // Call update on the list of contacts.
        // This results in one DML call for the entire list.
        update updatedList;
    }

    /*
    *
    *   Purpose :   Queries to select only those contacts that needs to be updated inside the loop itself and 
    *               changes are saved in a map and the map is updated at last
    *
    */
    public static void updating_level4(){
        // List to hold the new contacts to update.
        List<Contact> updatedList = new List<Contact>();
        Map<ID, Contact> mapWithContacts = new Map<ID, Contact>();
        for(Contact con : [Select Department , Description from Contact Where Department = 'Finance']) {            
            con.Description = 'New description 4';
            // Add updated contact sObject to the map.
            mapWithContacts.put(con.ID, con);
        }
        update mapWithContacts.values();
    }
}