/*
 * 	Description		:	Different types of Star Patterns
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	21/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 21/06/2022
 * */
public class PatternsController {
    public static void leftTriangleStarPattern(){
        for(integer i=1;i<=5;i++)
    	{
        string s='  ';
        for(integer j=1;j<=5;j++)
        {
            if(j>=6-i )
            {
                s = s + '*';
            }
            else
            {
                 s = s + '_';
            }
        }
        
        system.debug(s);
        
    }
    }
    public static void leftTriangleStarPatternSELF(){
        for(integer i=5;i>=1;i--)
    	{
            string s='  ';
            for(integer j=1;j<=5;j++)
            {
                if(j>=i )
                {
                    s = s + '*';
                }
                else
                {
                     s = s + '_';
                }
            }
            
            system.debug(s);
        
    	}
    }
    public static void downwardTriangleStarPatternSelf(){
        for(Integer i=5; i>=1;i--){
            String s=' ';
            for(Integer j=1;j<=i;j++){
                s+='*';
            }
            System.debug(s);
        }
    }
    public static void reversedPyramidStarPatternSELF(){
        for(Integer i=1;i<=5;i++){
            String s=' ';
            for(Integer j=1;j<=9;j++){
            	if(j>=i && j<=(9-i)+1){
                	if(math.mod(i,2)==0){
                    	if(math.mod(j,2)==0)
                        	s+='*';
                        else
                            s+='_';
                	}
                    else{
                        if(math.mod(j,2)==0)
                            s+='_';
                        else
                            s+='*';
                    }
                        
                }
                else{
                    s+='_';
                }               
            }
            System.debug(s);            
        }
    }
    public static void rightPascalsTriangleProgramSELF(){
         integer k=0;
		for(integer i=1;i<=10;i++)
    	{
        	if(i<=5)
                k++;
            else
                k--;
        	string s='  ';
        	for(integer j=1;j<=5;j++)
        	{
            	if(j<=k)
                	s = s + '*';
            	else
                 	s = s + '_';
        	}        
        	system.debug(s);        
    	}
    }
    public static void triangleStarPatternSELF(){
    	Integer mid=10/2;
        for(Integer i=1;i<=5;i++){
            String s=' ';
            for(Integer j=1;j<10;j++){
            	if(j==(mid-i)+1 || j==(mid+i)-1 || i==5)
                	s+='*';
                else
                	s+='_';                      
            }
            System.debug(s);
        }
    }
}