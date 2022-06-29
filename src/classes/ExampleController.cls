/*
 * 	Description		:	To understand an example of apex code to demonstrate transient keyword
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	29/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 29/06/2022
 * */
public class ExampleController {

    DateTime t1;
    transient DateTime t2;

    public String getT1() {
        if (t1 == null) t1 = System.now();
        return '' + t1;
    }

    public String getT2() {
        if (t2 == null) t2 = System.now();
        return '' + t2;
    }
}