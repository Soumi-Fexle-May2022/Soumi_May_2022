/*
 * Purpose         :   Creates options for users to select the number of transactions they want to see on mini statement action button,
 *                     and shows the users the selected number of transactions and the transactions are hyperlined so that they can refer to their details.
 * Created By      :   Soumi Chakraborty
 * Created Date    :   09/10/2022
 * Current Version :   V1.0
 * Revision Log    :   V_1.0 Created - Soumi Chakraborty - 09/10/2022
 */
import { LightningElement, api, wire } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import findTransactionsByContactId from '@salesforce/apex/TransactionController.findTransactionsByContactId';
export default class QuickMiniStatementComponent extends LightningElement {

    @api recordId
    showMiniStatement= false
    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    value = '5';
    get options() {
        return [
            { label: '5', value: '5' },
            { label: '10', value: '10' },
            { label: '15', value: '15' },
            { label: '20', value: '20' },
            { label: '25', value: '25' },
        ];
    }
    handleChange(event) {
        this.value = event.detail.value;
        this.showMiniStatement = false
    }
    handleClick(){ 
        this.showMiniStatement = true
    }
    columns =  [
        { label: 'Transaction Name', fieldName: 'transactionLink',type: 'url',
        typeAttributes:{label:{fieldName: 'Name'},target:'_blank'} },
        { label: 'Debit/Credit', fieldName: 'Type__c'},
        { label: 'Amount', fieldName: 'Amount__c', type: 'Decimal' },   
        { label: 'Date', fieldName: 'Transaction_Date__c', type: 'Date' }, 
        { label: 'Status', fieldName: 'Status__c'},
    ];
    @wire(findTransactionsByContactId,{contactId:'$recordId', selectedOption:'$value'})
    wiredTransactions({error,data}){
        if(data){
            this.transactions = data;
            let transactionList = [];
            this.transactions.forEach(record => {
                let transactionObj = {...record};
                transactionObj['transactionLink'] = '/lightning/r/Transaction_Entry__c/' + record.Id +'/view';
                transactionList.push(transactionObj);
            });
            this.data = transactionList;
        }
    }
}