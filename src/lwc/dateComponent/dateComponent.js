/*
 * Purpose         :   imports the image and the 3rd party library and uses it to show current date, time, week day
 *                     and greeting image when the button is clicked.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   08/09/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 08/09/2022
 */

import { LightningElement } from 'lwc';
import MOMENT from '@salesforce/resourceUrl/moment'
import NICE_DAY from '@salesforce/resourceUrl/nice_day'
import {loadScript} from 'lightning/platformResourceLoader'
export default class DateComponent extends LightningElement {
    currentDate=''
    isLibLoaded = false
    showGreetings = false
    renderedCallback(){ 
        if(this.isLibLoaded){ 
            return
        } else { 
            loadScript(this, MOMENT+'/moment/moment.min.js').then(()=>{ 
                this.setDateOnScreen()
            }).catch(error=>{ 
                console.error(error)
            })
            this.isLibLoaded = true;
        }
       
    }
    setDateOnScreen(){ 
        this.currentDate = moment().format('LLLL');
    }
    handleClick(){
        this.showGreetings=!this.showGreetings;
    }
    niceDay=NICE_DAY;
}