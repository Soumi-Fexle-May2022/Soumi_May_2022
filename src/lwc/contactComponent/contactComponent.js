/*
 * Purpose         :   Connects the apex class that getched all contacts
 * Created By      :   Soumi Chakraborty
 * Created Date    :   09/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 09/09/2022
 */
import { LightningElement, wire, api} from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';
export default class ContactComponent extends LightningElement {
    small;
    medium;
    large;  

     @wire(getContactList)
    contacts

    @api flexipageRegionWidth;

    connectedCallback(){
        if(this.flexipageRegionWidth=="SMALL"){
            this.small=12;
        }
        if(this.flexipageRegionWidth=="MEDIUM"){
            this.medium=12/3;
        }
        if(this.flexipageRegionWidth=="LARGE"){
            this.large=12/4;
        }
    }
}