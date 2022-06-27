/*
 * 	Description		:	To understand Apex Properties
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	24/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 24/06/2022
 * */
public with sharing class PropertyController {
     /*
     *    Purpose   :    To understand apex property and how it is called
     * 
     **/
    public integer prop {
        get {
             return prop; }
        set {
             prop = value; }
     }

     /*
     *    Purpose   :    To understand apex read only, read-write ,write only property
     * 
     **/
     public integer MyReadOnlyProp {
           get; 
     }
     public double MyReadWriteProp { 
          get;
          set;
     }
     public string MyWriteOnlyProp {
          set;
     }

     /*
     *    Purpose   :    To understand static property, how it accesses a static variable and how it is called
     * 
     **/
     private static integer StaticMember;
     private integer NonStaticMember;

     // The following produces a system error
     // public static integer MyBadStaticProp { return NonStaticMember; }

     public static integer MyGoodStaticProp { 
          get {return StaticMember;} 
          set { StaticMember = value; } 
     }  
     public integer MyGoodNonStaticProp { 
          get {return NonStaticMember;} 
          set { NonStaticMember = value; } 
     }

     /*
     *    Purpose   :    To understand property visibility
     * 
     **/
     // X is private for read and public for write
     public integer X { private get; set; }
     // Z can be read within the class but only subclasses can set it
     public integer Z { get; protected set; }
}