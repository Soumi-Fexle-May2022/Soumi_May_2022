/*
 * Purpose         :   Whenever the input field is changed it calls this updateProgress function so that it can dispatch a custom event to
 *                     parent component so that , parent component can assess the data (user entered number) of child component.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   06/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 06/09/2022
 */

import { LightningElement } from 'lwc';

export default class ChildLwc extends LightningElement {

    updateProgress(event){
        const myEvent=new CustomEvent('update',
        {
            detail: event.target.value
        });
        this.dispatchEvent(myEvent);
    }
}