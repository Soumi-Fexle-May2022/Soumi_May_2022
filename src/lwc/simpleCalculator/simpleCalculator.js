/*
 * Purpose         :   To perform the calculation on the user entered numbers and to derive the result that the simple calculator performs
 * Created By      :   Soumi Chakraborty
 * Created Date    :   02/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 02/09/2022
 */

import { LightningElement } from 'lwc';

export default class SimpleCalculator extends LightningElement {
    num1;
    num2;
    result;
    computeResult(event) {
        if(this.num1=='' || this.num2=='' || this.num1==undefined || this.num2==undefined ){
            this.result= 'Please enter valid input.'
        }
        else if(event.target.label=='Add'){
            this.result = Number(this.num1) + Number(this.num2);
        }
        else if(event.target.label=='Subtract'){
            this.result = Number(this.num1) - Number(this.num2);
        }
        else if(event.target.label=='Multiply'){
            this.result = Number(this.num1) * Number(this.num2);
        }
        else if(event.target.label=='Divide'){
            this.result = Number(this.num1) / Number(this.num2);
        }
        this.num1=null;
        this.num2=null;
    }
    handleChangeNum1(event) {
        this.num1 = event.target.value;
    }
    handleChangeNum2(event) {
        this.num2 = event.target.value;
    }
}