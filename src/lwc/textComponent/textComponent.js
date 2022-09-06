/*
 * Purpose         :   To store the texts returned by the methods of an apex class using async funcation
 * Created By      :   Soumi Chakraborty
 * Created Date    :   04/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 04/09/2022
 */

import { LightningElement } from 'lwc';
import getTextMethod1 from '@salesforce/apex/TextController.getTextMethod1';
import getTextMethod2 from '@salesforce/apex/TextController.getTextMethod2';
import getTextMethod3 from '@salesforce/apex/TextController.getTextMethod3';
export default class TextComponent extends LightningElement {
    text1;
    text2;
    text3;
    async invokeApexMethods(){
        try{
            const result1 = await getTextMethod1();
            const result2 = await getTextMethod2({param : result1});
            const result3 = await getTextMethod3({param : result2});
            this.text1=result1;
            this.text2=result2;
            this.text3=result3;
        }catch(error){
            console.log(error);
        }
        finally{
        }
    }
}