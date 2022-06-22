/*
 * 	Description		:	To understand Hierarchical Maps and Lists
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	22/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 22/06/2022
 * */
public with sharing class HierarchicalCollectionsController {
    public HierarchicalCollectionsController() {
        Map<String, Map<String, List<Student__c>>> yogaClassMap = new Map<String, Map<String, List<Student__c>>>();

        //1st Year List of Student
        List<Student__c> Class12Science = new List<Student__c>();
        Class12Science = [Select id, Name, Roll_Number__c, Class__c, Stream__c from Student__c where Class__c=12 and Stream__c ='Science'];
        Map<String, List<Student__c>> mapOfStudentOfClass12 = new Map<String, List<Student__c>>();
        mapOfStudentOfClass12.put('Computer Science',Class12Science);

        //1st Year List of Student
        List<Student__c> Class12Arts = new List<Student__c>();
        Class12Arts = [Select id, Name, Roll_Number__c, Class__c, Stream__c from Student__c where Class__c=12 and Stream__c ='Arts'];
        mapOfStudentOfClass12.put('Electronic',Class12Arts);

        //1st Year List of Student
        List<Student__c> Class11Arts = new List<Student__c>();
        Class11Arts = [Select id, Name, Roll_Number__c, Class__c, Stream__c from Student__c where Class__c=11 and Stream__c ='Arts'];
        Map<String, List<Student__c>> mapOfStudentOfClass11 = new Map<String, List<Student__c>>();
        mapOfStudentOfClass11.put('Electronic',Class11Arts);

        yogaClassMap.put('1stYear',mapOfStudentOfClass12);
        yogaClassMap.put('2ndYear',mapOfStudentOfClass11);
        
        System.debug('Student details of those who enrolled for yoga class: '+yogaClassMap);
	}
}