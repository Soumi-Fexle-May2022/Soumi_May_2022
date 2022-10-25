/*
* 	Description		:	To show the filtered searched transactions to the user.
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	13/10/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 13/10/2022
* 
* */
public class TransactionSearchController {
    
    public List<Transaction_Entry__c> transactions {get;set;}
    public String nameEntered {get;set;}
    public Decimal startingAmt {get;set;}
    public Decimal endingAmt {get;set;}
    public String selectedStatus {get;set;}
    public String accNum {get;set;}
    public String sdate{get;set;}
    public String edate{get;set;}

    /*
    *
    *   Purpose :   To fetch transaction details according to selected search key in Visualforce page and to return it back to the VF Page.
    *               
    */    
    public PageReference search_now(){

         if(nameEntered!=null && nameEntered!=''){
            transactions = [SELECT Id, Name, Type__c, Amount__c,Status__c, Transaction_Date__c,Contact__c,
                             Contact__r.Account_Number__c FROM Transaction_Entry__c WHERE Name like :(nameEntered+'%')];
         }
         else if(startingAmt!=null && endingAmt!=null && startingAmt!=0 && endingAmt!=0){
            transactions = [SELECT Id, Name, Type__c, Amount__c,Status__c, Transaction_Date__c,Contact__c,
                             Contact__r.Account_Number__c FROM Transaction_Entry__c WHERE Amount__c >= :(startingAmt) AND  Amount__c <= :(endingAmt)];            
        }
        else if(accNum!=null && accNum!=''){
            transactions = [SELECT Id, Name, Type__c, Amount__c,Status__c, Transaction_Date__c,Contact__c,
                             Contact__r.Account_Number__c FROM Transaction_Entry__c WHERE Contact__r.Account_Number__c like :(accNum+'%')];
        }
        else if(selectedStatus!=null && selectedStatus!='None' && selectedStatus!=''){
            transactions = [SELECT Id, Name, Type__c, Amount__c,Status__c, Transaction_Date__c,Contact__c,
                             Contact__r.Account_Number__c FROM Transaction_Entry__c WHERE Status__c =:(selectedStatus)];
        }
        else if(sdate!=null && edate!=null){
            Date startDate= Date.parse(sdate);
            Date endDate= Date.parse(edate);
            transactions = [SELECT Id, Name, Type__c, Amount__c,Status__c, Transaction_Date__c,Contact__c,
                             Contact__r.Account_Number__c FROM Transaction_Entry__c WHERE Transaction_Date__c>=:startDate AND Transaction_Date__c<=:endDate];
        }
        nameEntered='';
        startingAmt=0;
        endingAmt=0;
        accNum='';
        selectedStatus='None';
        return null;
    }
}