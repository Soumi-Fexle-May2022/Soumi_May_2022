/*
 * Purpose         :   Publishes or sends the entered message to another component using LMS.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   13/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 13/09/2022
 */
import { LightningElement, wire } from 'lwc';
import SAMPLEMC from "@salesforce/messageChannel/SampleMessageChannel__c"
import {MessageContext, publish} from 'lightning/messageService'
export default class LmsComponentA extends LightningElement {
    inputValue

    @wire(MessageContext)
    context

    inputHandler(event){
        this.inputValue = event.target.value
    }

    publishMessage(){
        const message={
            lmsData:{
                value:this.inputValue
            }
        }
        //publish(messageContext, messageChannel, message)
        publish(this.context, SAMPLEMC, message)
    }
}