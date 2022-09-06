/*
 * 	Description		:	This class contains 3 methods that return 3 strings respectively
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	04/09/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 04/09/2022
 * */

public with sharing class TextController {
    @AuraEnabled(Cacheable = true)
    public static string getTextMethod1(){
        return 'METHOD-1';
    }
    @AuraEnabled(Cacheable = true)
    public static string getTextMethod2(String param){
        String strToReturn=param+' METHOD-2';
        return strToReturn;
    }
    @AuraEnabled(Cacheable = true)
    public static string getTextMethod3(String param){
        String strToReturn=param+' METHOD-3';
        return strToReturn;
    }
}