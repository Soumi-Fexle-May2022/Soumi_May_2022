/*
 * 	Description		:	One implementation of the interface for customers
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	28/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 28/06/2022
 * */
public class CustomerPurchaseOrder implements PurchaseOrder {
    public Double discount() {
        return .05;  // Flat 5% discount
    }
    public CustomerPurchaseOrder(){
        List<PurchaseOrder> POs = new PurchaseOrder[] {};
        List<CustomerPurchaseOrder> CPOs = new CustomerPurchaseOrder[]{};
        POs = CPOs;
    }
}