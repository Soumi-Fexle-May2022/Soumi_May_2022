/*
 * 	Description		:	Another implementation of the interface for employees
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	28/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 28/06/2022
 * */
public class EmployeePurchaseOrder implements PurchaseOrder {
    public Double discount() {
      return .10;  // It’s worth it being an employee! 10% discount
    } 
}