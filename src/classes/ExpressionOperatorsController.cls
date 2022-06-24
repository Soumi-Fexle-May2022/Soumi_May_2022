/*
 * 	Description		:	To understand the different expresiion operators
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	24/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 24/06/2022
 * */
public with sharing class ExpressionOperatorsController {
    public ExpressionOperatorsController() {
        Integer x, y, z, t;
        x=5;
        y=10;
        z=15;
        t=y;             //Assignment operator
        System.debug('Value of t is now = '+t);
        t+=x;            //Addition assignment operator
        System.debug('Modified value of t after adding '+x+' is = '+t);
        t-=x;            //Subtraction assignment operator
        System.debug('Modified value of t after subtracting '+x+' is = '+t);
        t*=y;            //Multiplication assignment operator
        System.debug('Modified value of t after multiplying with '+y+' is = '+t);
        t/=x;            //Division assignment operator
        System.debug('Modified value of t,containing quotient after dividing by '+x+' is = '+t);
        //Post Increment operator
        System.debug('Modified value of t after post increment = '+ t++);
        //Pre Increment operator
        System.debug('Modified value of t after pre increment = '+ ++t);


        Boolean a,b,c;
        a=true;
        b=false;
        c=true;
        a |= b;          //OR assignment operator
        System.debug('Value of a is = '+a);
        a &= b;          //AND assignment operator
        System.debug('Value of a is = '+a);
        Integer result=0;
        result= a?y:z;   //Ternary operator 
        System.debug('Boolean "a" was '+a+' so "result" = '+result);
        result= c?y:z;   //Ternary operator 
        System.debug('Boolean "c" was '+c+' so "result" = '+result);
    }
}