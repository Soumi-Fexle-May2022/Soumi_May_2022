/*
 * 	Description		:	To understand different control flow statements- if-else, different loops
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	24/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 24/06/2022
 * */
public with sharing class ControlFlowStatementsController {
    /*
    *short if else
    *normal if else
    *if-else if else
    */
    public static void ifElsePractice() {
        Integer x, sign;
        x=0;
        if (x <= 0) if (x == 0) sign = 0; else sign = -1;
        System.debug('For x = '+x+', value of sign = '+sign);
        //The above code is equivalent to:-
        x=-3;
        if (x <= 0) {
            if (x == 0) {
                sign = 0; 
            }
             else  {
                sign = -1;
            }
        }
        System.debug('For x = '+x+', value of sign = '+sign);
        //if else if ladder for multiple conditional statements checking
        Integer place =2;
        String medal_color=' ';
        if (place == 1) {
            medal_color = 'gold';
        } else if (place == 2) {
            medal_color = 'silver';
        } else if (place == 3) {
            medal_color = 'bronze';
        } else {
            medal_color = null;
        }
        System.debug('You scored position '+place+' so you got '+medal_color+' medal.');
    }
    /*
    *do while loops
    *while loops
    *for loop
    *for each loop to iterate over a list
    */
    public static void loopsPractice(){
        System.debug('Displaying 1 to 10 using do while loop');
        Integer count = 1;
        do {
            System.debug(count);
            count++;
        } while (count < 11);
        System.debug('Displaying 10 to 1 using While loop');
        Integer n = 10;
        while (n>0) {
            System.debug(n);
            n--;
        }
        System.debug('Displaying odd numbers between 1 to 20 using for loops');
        for (Integer i = 1; i <=20; i+=2)
            System.debug(i);
        System.debug('Iterating a list of names using for each loop');
        List<String> namesList = new List<String>{'Anima','Rajkumar','Soumi','Arunava'};
        for (String name : namesList) {
            System.debug(name);
        }
    }
}