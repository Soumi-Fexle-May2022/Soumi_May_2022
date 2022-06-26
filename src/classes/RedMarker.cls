/*
 * 	Description		:	To understand inheritence. RedMarker is the child class of Marker class
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/06/2022
 * */
public class RedMarker extends Marker {
    public override void write() {
        System.debug('Writing some text in red.');
    } 

    // Method only in this class
    public Double computePrice() {
        return 1.5;
    }
}