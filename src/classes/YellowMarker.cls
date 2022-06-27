/*
 * 	Description		:	To understand inheritence. YellowMarker is the child class of Marker class
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/06/2022
 * */
public class YellowMarker extends Marker {
    public override void write() {
        System.debug('Writing some text using the yellow marker.');
    } 
}