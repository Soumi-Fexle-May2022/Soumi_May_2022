/*
 * Purpose         :   Publishes or sends the clicked contact out of all the contacts from the list.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   13/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 13/09/2022
 */
import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ContactController.getContactList';

// Import message service features required for publishing and the message channel
import { publish, MessageContext } from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/Record_Selected__c';

export default class LmsPublisherWebComponent extends LightningElement {
    @wire(getContactList)
    contacts;
    
    @wire(MessageContext)
    messageContext;

    // Respond to UI event by publishing message
    handleContactSelect(event) {
        const payload = { recordId: event.target.contact.Id };

        publish(this.messageContext, recordSelected, payload);
    }
}