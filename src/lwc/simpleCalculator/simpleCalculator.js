import { LightningElement } from 'lwc';

export default class SimpleCalculator extends LightningElement {
    num1;
    num2;
    result;
    addNumbers() {
        this.result = Number(this.num1) + Number(this.num2);
    }
    subtractNumbers() {
        this.result = Number(this.num1) - Number(this.num2);
    }
    multiplyNumbers() {
        this.result = Number(this.num1) * Number(this.num2);
    }
    divideNumbers() {
        this.result = Number(this.num1) / Number(this.num2);
    }
    handleChangeNum1(event) {
        this.num1 = event.target.value;
    }
    handleChangeNum2(event) {
        this.num2 = event.target.value;
    }
}