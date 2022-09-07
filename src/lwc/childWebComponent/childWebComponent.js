/*
 * Purpose         :   Assigns the initial value of the input field when the page loads and helps in showing the instant result when input is 
 *                     further changed. Creates a public method using @api so that parent can fire it to reset input value when a button from
 *                     parent component is clicked.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   06/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 06/09/2022
 */

import { LightningElement, api } from 'lwc';

export default class ChildWebComponent extends LightningElement {
    val=20
    changeHandler(event){
        this.val=event.target.value
    }
    @api resetNumber(){
        this.val=50
    }
    @api myMessage;
}