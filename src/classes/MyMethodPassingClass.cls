/*
 *  Description     :   To understand call by value and call by reference based on sir's example
 * 
 *  Created By      :   Soumi Chakraborty
 * 
 *  Created Date    :   28/06/2022
 * 
 *  Revision Logs   :   V_1.0 - Created By - Soumi Chakraborty - 28/06/2022
 * */
public with sharing class MyMethodPassingClass {
    Student__c s1 = [select Id, Name, Roll_Number__c, Overall_Grade__c from Student__c order by createdDate DESC limit 1];
    Set<String> fruits = new Set<string>{'Mango','Kiwi','Avocado','Cherry'};
    Integer i=10;
    String fruitName='berry';
    public MyMethodPassingClass() {
        System.debug('-----Example of Call By Reference-----');
        System.debug('Value of Student name before call by reference = '+s1.Name);
        System.debug('Value of Set of fruits before call by reference = '+fruits);
        manipulateReference(s1, fruits);
        System.debug('Value of Student name after call by reference = '+s1.Name);
        System.debug('Value of Set of fruits after call by reference = '+fruits);
        System.debug('\n-----Example of Call By Value-----');
        System.debug('Value of Integer"i" before call by value = '+i);
        System.debug('Value of String "fruitName" before call by value = '+fruitName);
        checkCallByValue(i, fruitName);
        System.debug('Value of Integer"i" after call by value = '+i);
        System.debug('Value of String "fruitName" after call by value = '+fruitName);
    }

    /*
    *
    *   Purpose     :   To understand the passing by reference
    *
    */
    public void manipulateReference(Student__c stData, Set<String> fruits){
        for(Integer i=0;i<3;i++)
            stData.Name = stData.Name + i;
        System.debug('Value of Student name during call by reference = '+s1.Name); 
        fruits.add('Jacfruit');
        fruits.add('Orange');
        System.debug('Value of Set of fruits during call by reference = '+fruits);
    }

    /*
    *
    *   Purpose     :   To understand the passing by value
    *
    */
    public void checkCallByValue(Integer i, String fruitName){
        i=50;
        fruitName='Straw'+fruitName;
        System.debug('Value of Integer "i" during call by value = '+i);
        System.debug('Value of String "fruitName" during call by value = '+fruitName);
    }
}