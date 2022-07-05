/*
 * 	Description		:	To understand super keyword froma child class that is inheriting from Super sclass
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	29/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 29/06/2022
 * */
public class Subclass extends Superclass {
    public Subclass() {
        super('Mr. ', 'Jacob', 'Clapentrap');
    }
    public Subclass(String name){
        myFirstName=name;
    }
    public override String getFirstName() {
        myFirstName='Jack';
        return myFirstName;
    }
    public override void printName() {
          super.printName();
          System.debug('But you can call me ' + super.getFirstName());
          System.debug('My nickname is '+this.getFirstName());
    }

  }