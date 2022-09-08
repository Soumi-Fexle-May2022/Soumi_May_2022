/*
 * Purpose         :   Assigns the user entered value to the value of progress bar
 * Created By      :   Soumi Chakraborty
 * Created Date    :   06/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 06/09/2022
 */

import { LightningElement, track } from 'lwc';

export default class ParentLwc extends LightningElement {
    @track proggressValue;
    updateProgress(event){
        this.proggressValue= event.detail;
    }
}