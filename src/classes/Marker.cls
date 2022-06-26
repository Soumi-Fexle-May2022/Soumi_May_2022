/*
 * 	Description		:	To understand inheritence. Marker class is the base class
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	26/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 26/06/2022
 * */
public virtual class Marker {
    public virtual void write() {
        System.debug('Writing some text.');
    }

    public virtual Double discount() {
        return .05;
    }
}