/*
 * 	Description		:	Controlls the two implemented classes of PurchaseOrder
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	28/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 28/06/2022
 * */
public class ProcessPurchaseOrderController {
    public ProcessPurchaseOrderController() {
        PurchaseOrder order1 =new CustomerPurchaseOrder();
        PurchaseOrder order2 =new EmployeePurchaseOrder();

        processOrder(order1);
        processOrder(order2);
    }
    public void processOrder(PurchaseOrder order){
        System.debug('Check discount : '+order.discount());
    }
}