/*
 * 	Description		:	To understand super keyword we created a super class that is inherited by subclass
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	29/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 29/06/2022
 * */
public virtual class SuperClass {
    public String mySalutation;
    public String myFirstName;
    public String myLastName;

    public SuperClass() {

        mySalutation = 'Mr.';
        myFirstName = 'Carl';
        myLastName = 'Vonderburg';
    }

    public SuperClass(String salutation, String firstName, String lastName) {

        mySalutation = salutation;
        myFirstName = firstName;
        myLastName = lastName;
    }

    public virtual void printName() {

        System.debug('My name is ' + mySalutation + myLastName);
    }

    public virtual String getFirstName() {
        return myFirstName;
    }
}