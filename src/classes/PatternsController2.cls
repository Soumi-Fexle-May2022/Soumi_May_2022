/**
* 	Description		:	Different types of Star Patterns part 2
* 
*  Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	22/06/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 22/06/2022
**/
public with sharing class PatternsController2 {

    /*  *_*_*_*_*
    *   _*_*_*_*_
    *   __*_*_*__
    *   ___*_*___
    *   ____*____
    *   ___*_*___
    *   __*_*_*__
    *   _*_*_*_*_
    *   *_*_*_*_*   */
    public static void sandglassStarPatternProgram() {
        integer k=0;
        for(integer i=1;i<=10;i++)
        {
            if(i<=5){k++;} else{k--;}
            if(i==6){k++;} 
            string s='  ';
            for(integer j=1;j<=9;j++)
            {
                if(j>=k && j<=10-k)
                    s = s + '*';
                else
                    s = s + '_';
            }
            System.debug(s);

        }
    }

    /*  ____*____
    *   ___***___
    *   __*****__
    *   _*******_
    *   *********   */
    public static void pyramidPatternProgram(){
        for(integer i=0;i<=4;i++)
        {
            string s = '  ';
            for(integer j=0;j<=8;j++)
            {
                if(j>=4-i && j<=4+i )
                    s = s + '*';
                else
                    s = s + '_';
            }        
            System.debug(s);        
        }
    }

    /* 1
    *  23
    *  456
    *  78910
    *  1112131415  */
    public static void numberPatternProgram(){
        integer k=1;
        for(integer i=1;i<=5;i++)
        {
            string s = '';
            for(integer j=1;j<=i;j++)
            {
                if(j<=i)
                {
                    s = s + k;
                    k++;
                }
            }        
            System.debug(s);
        
        }
    }

    /*  5
    *   54
    *   543
    *   5432
    *   54321   */
    public static void descendingOrderPatternProgram(){
        for(integer a=5; a>0; a--){
            string s='  ';  
            for(integer j=5; j>=a; j--)
                    s=s+j;
            System.debug(s);
        }
    }
}