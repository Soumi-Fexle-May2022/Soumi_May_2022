/*
 * 	Description		:	To understand method overloading
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	28/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 28/06/2022
 * */
public with sharing class ExampleOfMethodOverloading {
    public ExampleOfMethodOverloading() {
        String name='Soumi', favDish = 'Biriyani',location='Kolkata';
        Integer age = 18, cls=12;
        System.debug('-----Simple example of method overloading-----');
        displayInfo(name, favDish, cls);
        displayInfo(name,age);
        displayInfo(name, location);
    }
    public static void displayInfo(String name, Integer age){
        System.debug('My name is '+name+' and my age is '+age);
    }
    public static void displayInfo(String name, String favDish, Integer cls){
        System.debug('My name is '+name+' , my favourite dish is '+favDish+'. I am studying in class '+cls);
    }
    public static void displayInfo(String name, String location){
        System.debug('My name is '+name+' and I am from '+location);
    }
}