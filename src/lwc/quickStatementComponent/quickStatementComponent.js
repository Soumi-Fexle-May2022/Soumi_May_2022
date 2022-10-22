/*
 * Purpose         :   Lets users choose a date range and checks if the date range is valid and displays the transactions , with pagination and sorting.
 *                     Also the user can export that transaction details for the selected date range in form of CSV , PDF or can also email PDF to contact's email.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   10/10/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 10/10/2022
 */
import { LightningElement,api, wire, track } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import findTransactionsByDateRange from '@salesforce/apex/TransactionController.findTransactionsByDateRange';
import sendEmailPdf from '@salesforce/apex/TransactionController.sendEmailPdf';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns =  [
    { label: 'Transaction Name', fieldName: 'Name',sortable: "true"},
    { label: 'Debit/Credit', fieldName: 'Type__c', sortable: "true"},
    { label: 'Amount', fieldName: 'Amount__c', type: 'Decimal', sortable: "true" },   
    { label: 'Date', fieldName: 'Transaction_Date__c', type: 'Date', sortable: "true" }, 
    { label: 'Status', fieldName: 'Status__c', sortable: "true"},
];
export default class QuickStatementComponent extends LightningElement {
    startVal;
    endVal;
    diffDates;
    result;
    showStatement=false;
    csvSelected=true;
    pdfSelected=false;
    emailPdfSelected=false;
    @api recordId;
    @track transactions={};
    transactionList=[];
    @track data;
    @track columns = columns;
    @track sortBy;
    @track sortDirection;

    isPageChanged = false;
    @track page = 1;
    @track totalPage = 0;
    @track startingRecord = 1;
    @track endingRecord = 0;
    @track startingRecord = 1;
    @track endingRecord = 0; 
    @track totalRecountCount = 0;
    @track pageSize = 5;
   

    @wire(findTransactionsByDateRange,{contactId:'$recordId', startDate:'$startVal', endDate:'$endVal'})
    wiredTransactions(result) {
        if (result.data) {
            this.transactions = result.data;
            this.data = result.data;
            this.processRecords(this.data);
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.data = undefined;
        }
    }
    processRecords(data){
        this.items = data;
            this.totalRecountCount = data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            
            this.data = this.items.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;
            this.columns = columns;
    }
    previousHandler() {
        this.isPageChanged = true;
        if (this.page > 1) {
            this.page = this.page - 1; 
            this.displayRecordPerPage(this.page);
        }
    }
    nextHandler() {
        this.isPageChanged = true;
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1;
            this.displayRecordPerPage(this.page);            
        }
    }
    displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 

        this.data = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }
    doSorting(event) {
        this.sortBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sortData(this.sortBy, this.sortDirection);
    }
    sortData(fieldname, direction) {
        let parseData = JSON.parse(JSON.stringify(this.data));
        let keyValue = (a) => {
            return a[fieldname];
        };
        let isReverse = direction === 'asc' ? 1: -1;
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; 
            y = keyValue(y) ? keyValue(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.data = parseData;
    } 
    value = 'CSV'; 
    get options() {
        return [
            { label: 'CSV', value: 'CSV' },
            { label: 'PDF', value: 'PDF' },
            { label: 'Email PDF', value: 'EmailPDF' }
        ];
    }
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    handleChangeStartDt(event) {
        this.startVal=event.target.value;
        this.startDate = new Date(this.startVal);
        this.showStatement= false;
        this.result='';
        this.page = 1;
    }
    handleChangeEndDt(event) {
        this.endVal=event.target.value;
        this.endDate = new Date(this.endVal);
        this.showStatement= false;
        this.result='';
        this.page = 1;
    }
    showTransactions(event){
        this.diffDates=this.endDate-this.startDate;
        this.diffDates=parseInt(this.diffDates/ (1000*60*60*24));

        if(this.diffDates>180){
            this.result='Range exceeded 6 months, please change dates.';
        }
        else if(this.diffDates<0){
            this.result='Start Date cannot exceed End Date.';
        }
        else{
            this.result='Displaying the transactions';
            this.showStatement= true;

        }
    }
    columnHeader = ['Transaction Name', 'Type', 'Amount', 'Date', 'Status' ];
    handleRadioChange(event) {
        const selectedOption = event.detail.value;
        if (selectedOption == 'CSV'){
            this.csvSelected=true;
        }else{
            this.csvSelected=false;
        }    
        
        if (selectedOption == 'PDF'){
           this.pdfSelected=true;           
        }else{
            this.pdfSelected=false;
        }       
 
        if (selectedOption == 'EmailPDF'){
            this.emailPdfSelected=true;
        }else{
            this.emailPdfSelected=false;
        }
    }
    downloadReport(){
        
        if(this.csvSelected==true){
            let doc;
            let i=0;
            this.columnHeader.forEach(element => {
                if(i==0){
                    doc=element +',';
                    i=i+1;
                }
                else{
                    doc += element +','
                }
            });
            doc += '\n';
            this.transactions.forEach(record => {
                doc += record.Name+',';
                doc += record.Type__c+',';
                doc += record.Amount__c+',';
                doc += record.Transaction_Date__c+',';
                doc += record.Status__c+',';
                doc += '\n';
            });
            var element = 'data:text/csv;charset=utf-8,' + encodeURIComponent(doc);
            let downloadElement = document.createElement('a');
            downloadElement.href = element;
            downloadElement.target = '_self';
            downloadElement.download = 'Transaction Details.csv';
            document.body.appendChild(downloadElement);
            downloadElement.click();
        }

        else if(this.pdfSelected==true){
            let urlString = window.location.href;
            let urlWithValues = urlString.substring(0, urlString.indexOf(".com/"));
            urlWithValues = urlWithValues.concat('.com/apex/TransactionPdfPage?id='+this.recordId+
                            '&startDate='+this.startVal+'&endDate='+this.endVal);            
            window.open(urlWithValues);
        }

        else if(this.emailPdfSelected==true){
           
            sendEmailPdf({ startDt : this.startVal, endDt : this.endVal, contactRecordId : this.recordId})
            .then((output) =>{
                console.log(output)
            })
            .catch((error) =>{
                console.log(error)
            });
            const event = new ShowToastEvent({
                title: 'Email Sent',
                message: 'Contact has been mailed the transaction details pdf',
                variant: 'success'
            });
            this.dispatchEvent(event);    
        }
    }  
}