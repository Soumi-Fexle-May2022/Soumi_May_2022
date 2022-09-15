/*
 * Purpose         :   Displays the message passed in the "name" variable from aura component.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   13/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 13/09/2022
 */
import { LightningElement, api } from 'lwc';

export default class HelloWorld extends LightningElement {
    @api name;
}