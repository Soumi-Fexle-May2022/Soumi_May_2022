/*
 * Purpose         :   Calls the resetNumber method defined in child whenever the button present in parent component is clicked.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   06/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 06/09/2022
 */

import { LightningElement } from 'lwc';

export default class ParentWebComponent extends LightningElement {
    msg="Hey, how are you??"
    handleClick(){
        this.template.querySelector('c-child-web-component').resetNumber()
    }
}