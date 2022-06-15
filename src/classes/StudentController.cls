public class StudentController {
    public static void createStudentData(){
        Student__c s1 = new Student__c();
        //Compulsory fields-
        s1.Roll_Number__c = 26;
        s1.Name = 'Archana Bose';
        s1.Father_Name__c = 'Aditya Bose';
        s1.Mobile_Number__c = '986114611';
        s1.Father_s_Mobile_Number__c = '7692789811';
        s1.Email_Address__c = 'archana.bose@gml.cm';
        s1.Overall_Grade__c = 'A';
        s1.About_Self__c = 'I am Archana';
        s1.Stream__c='Science';
        s1.Class__c= 12;        
        s1.Current_Year__c = 1;
        
        //Non compulsory fields-
        s1.Fees_Submitted__c = false;
        s1.Home_Phone__c = '1234545009';
        s1.Pending_Fees_Amount__c = 125.50;
        s1.Exam_Fees_Submitted__c = false;
        s1.Pending_Fees_Amount__c = 225.00;
      
        // Present in Teacher layout only-
        s1.X1st_Sem_Percentage__c = 62 ;
        s1.X1st_Sem_Back__c = 'Yes';
        s1.Subjects_in_which_back__c = 'English'; 
        s1.X2nd_Sem_Percentage__c = 33;
        s1.X3rd_Sem_Back__c = 'Yes';
        s1.Subjects_in_which_back_in_3rd_sem__c = 'English;Physics;chemistry';
        s1.X4th_Sem_Percentage__c = 57;
        s1.X4th_Sem_Back__c = 'No';
        s1.Subjects_in_which_back_in_4th_sem__c = 'English';
         
         //Present in Registrar layout only-
        s1.Is_Donation__c = true;
        s1.Donation_Amount__c = 500.00;
        s1.Donation_Details__c = 'Old Age Home';
      
        s1.Bank_Name__c = 'Indian Bank';
        s1.IFCS_Code__c = 'SBIN18880';
        s1.Account_Number__c = 17645686;
        s1.Credit_Card_No__c = '145774557';
        s1.Bank_Phone_Number__c = '777777777' ;
        s1.City__c='Jaipur';
        s1.State__c = 'Rajasthan';
        insert s1;
    }
    public static void getStudentDetails(){
        //Single student
        Student__c s2 = [select Id, Name, Roll_Number__c, Overall_Grade__c from Student__c order by createdDate DESC limit 1];
		System.debug('This is my latest student'+ s2);
        //Multiple students
        List<Student__c> studentList = [select Id, Name, Roll_Number__c, Overall_Grade__c from Student__c order by createdDate DESC limit 5];
        for (Student__c student : studentList){
            System.debug('Student->'+ student);
        }
    }
}