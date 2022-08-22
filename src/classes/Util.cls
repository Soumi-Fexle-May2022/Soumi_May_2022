/*
* 	Description		:	The future method, insertUserWithRole, which is defined in the Util class, performs the insertion of a user
*                       with the COO role
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	20/08/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 20/08/2022 
* 
* */
public class Util {
    @future
    public static void insertUserWithRole(
        String uname, String al, String em, String lname) {

        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        UserRole r = [SELECT Id FROM UserRole WHERE Name='COO'];
        // Create new user with a non-null user role ID 
        User u = new User(alias = al, email=em, 
            emailencodingkey='UTF-8', lastname=lname, 
            languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, userroleid = r.Id,
            timezonesidkey='America/Los_Angeles', 
            username=uname);
        insert u;
    }
}