/*
 * 	Description		:	Star Patterns given as assignments
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	21/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 21/06/2022
 * 	
 *  Assignment patterns : 1.  ____*                 Line #27.
 * 							  ___**
 * 							  __***
 * 							  _****
 * 							  *****
 * 							  _****
 * 							  __***
 * 							  ___**
 * 							  ____*
 * 
 * 						  2.  *********             Line #44.
 * 							  _*_____*_
 * 							  __*___*__
 * 							  ___*_*___
 * 							  ____*____
 * */
public class PatternAssignmentController {
    public static void leftTrianglePascalsProgramSELF(){
        Integer k=6;
        for(Integer i=1;i<10;i++){
            if(i<=5)
                k--;
            else
                k++;
            String s=' ';
            for(Integer j=1;j<=5;j++){
                if(j>=k)
                    s+='*';
                else
                    s+='_';
            }
            System.debug(s);
        }
    }
    public static void downTriangleStarPatternSELF(){
        for(Integer i=1;i<=5;i++){
            String s=' ';
            for(Integer j=1;j<10;j++){
                if(i==1 || j==i || j==10-i){
                    s+='*';
                }
                else{
                    s+='_';
                }
            }
            System.debug(s);
        }
    }
}