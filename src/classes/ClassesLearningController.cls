/*
 * 	Description		:	To understand methods,classes,objects,variables
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	24/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 24/06/2022
 * */
    public with sharing class ClassesLearningController {
    Integer a=0,b=0;

    //Default Constructor
    public ClassesLearningController() {
        a=12;
        System.debug('Initialized value of "a" using Default constructor '+a);
    }

    //Paremeterized Constructor
    public ClassesLearningController(Integer t) {
        a=t;
        System.debug('Initialized value of "a" using Parameterized constructor '+a);
    }

    //Paremeterized Constructor
    public ClassesLearningController(Integer t, Integer x) {
        a=t;
        b=x;
        System.debug('Initialized value of "a" and "b" using Parameterized constructor = '+a+', '+b);
    }

    //Controlling method to run the constructors
    public static void printValues(){
        ClassesLearningController object1 = new ClassesLearningController();
        //Constructor overloading
        ClassesLearningController object2 = new ClassesLearningController(70);
        ClassesLearningController object3 = new ClassesLearningController(70, 30);
    }
    /*Passing By Value
    *
    *   Purpose     :   To understand the passing by value
    *
    */
    public static void debugStatusMessage() {   
        System.debug('Example of Passing by Value :- ');     
        String msg = 'Original value';
        System.debug('Initial value of "msg" = '+msg);
        processString(msg);
        // The value of the msg variable didn't
        // change; it is still the old value.
        System.debug('Value of "msg" after its value chamged by passing by value = '+msg);
    }    
    public static void processString(String s) {
        s = 'Modified value';
        System.debug('Trying to change the value by = '+s);
    }

    /*Passing By Reference
    *
    *   Purpose     :   To understand the passing by reference
    *
    */
    public static void addMarks() {
        System.debug('Example of Passing by Reference :- ');
        List<Integer> midSemMarks = new List<Integer>();        
        reference(midSemMarks);
        // The list is modified and contains five items
        // as expected.
        System.debug('no. of subjects having marks in Mid Sem = '+midSemMarks.size());        
        
        List<Integer> endSemMarks = new List<Integer>();
        referenceNew(endSemMarks);
        // The list is not modified because it still points
        // to the original list, not the new list 
        // that the method created.
        System.debug('no. of subjects having marks in End Sem = '+endSemMarks.size());     
    }
            
    public static void reference(List<Integer> m) {
        // Adding marks for 5 subjects.
        m.add(70);
        m.add(68);
        m.add(75);
        m.add(80);
        m.add(82);
    }    
        
    public static void referenceNew(List<Integer> m) {
        // Assign argument to a new List of Integer
        // five subjects marks
        m = new List<Integer>{55, 59, 62, 60, 63};
    }

    /*Passing By Reference
    *
    *   Purpose     :   To understand an example of Static initialization to initalize static map
    *
    */
    class RGB {

        Integer red;
        Integer green;
        Integer blue;

        RGB(Integer red, Integer green, Integer blue) {
            this.red = red;
            this.green = green;
            this.blue = blue;
        }
     }

   static Map<String, RGB> colorMap = new Map<String, RGB>();

    static {
        colorMap.put('red', new RGB(255, 0, 0));
        colorMap.put('cyan', new RGB(0, 255, 255));
        colorMap.put('magenta', new RGB(255, 0, 255));
        System.debug('Color Map : '+colorMap);
    }
}