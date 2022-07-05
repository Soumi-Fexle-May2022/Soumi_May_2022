/*
 * 	Description		:	To understand Classes and casting
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	03/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 03/07/2022
 * */
public class CustomReport extends Report {
    public CustomReport(){
  // Create a list of report objects
  Report[] Reports = new Report[5];

  // Create a custom report object
  CustomReport a = new CustomReport();

  // Because the custom report is a sub class of the Report class,
  // you can add the custom report object a to the list of report objects
  Reports.add(a);

  // The following is not legal:
  // CustomReport c = Reports.get(0);
  // because the compiler does not know that what you are
  // returning is a custom report. 

  // You must use cast to tell it that you know what
  // type you are returning. Instead, get the first item in the list
  // by casting it back to a custom report object
  CustomReport c = (CustomReport) Reports.get(0);
    }
}