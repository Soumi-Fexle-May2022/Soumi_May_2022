/*
* 	Description		:	To insert, update related records for Opportunity under its 4 child objects, and to send email to owner.
* 
*   	Created By		:	Soumi Chakraborty
* 
* 	Created Date		:	29/07/2022
* 
* 	Revision Logs		: 	V_1.0 - Created By - Soumi Chakraborty - 29/07/2022 
* 
* */
public class OpportunityTriggerHelper {
    public static Opportunity currentNewOpp= new Opportunity();
    public static Set<SObject> setOfAllRecordsToInsert = new Set<SObject>();           
    public static Map<String,SObject> mapOfAllRecordsToUpdate = new Map<String,SObject>();
    public static Set<String> setOfUniqueSuccessInsOrUpRecNames=new Set<String>();
    public static List<String> listOfDuplicateRecNames = new List<String>();
    public static List<String> listOfInvalidRecNames = new List<String>();
    public static List<Automobile_Sensor__c> fetchedSensorRec =new List<Automobile_Sensor__c>();
    public static List<Automobile_Presence_Sensor__c> fetchedPrSensorRec=new List<Automobile_Presence_Sensor__c>();
    public static List<Automobile_TDU__c> fetchedTduRec =new List<Automobile_TDU__c>();
    public static List<Automobile_Tag__c> fetchedTagRec =new List<Automobile_Tag__c>();
    public static List<SObject> fetchedRecFromAllObjs = new List<SObject>();    
   /*
    *
    *   Purpose :   To insert or update related records of Opportunity when stage is in Shipped to Customer or Return to HQ or
    *               Return to Customer.
    *
    */
    public static void populateChildObjRecords(List<Opportunity> newOppsList, List<Opportunity> oldOppsList){  
        //These queries fetch records that are aleady in database
        fetchedSensorRec =[SELECT Name,Opportunity__c,Account__c FROM Automobile_Sensor__c];
        fetchedPrSensorRec=[SELECT Name,Opportunity__c,Account__c FROM Automobile_Presence_Sensor__c];
        fetchedTduRec =[SELECT Name,Opportunity__c,Account__c FROM Automobile_TDU__c];
        fetchedTagRec =[SELECT Name,Opportunity__c,Account__c FROM Automobile_Tag__c];
        List<String> listOfRecNamesToInsert= new List<String>();
        Set<String> setOfNamesFromTagsOrHqToUpdate = new Set<String>();
        //Taking out each opportunity from all Opportunities (Trigger.new)
        for(Opportunity opp : newOppsList){ 
            fetchedRecFromAllObjs.addAll(fetchedSensorRec);
            fetchedRecFromAllObjs.addAll(fetchedPrSensorRec);
            fetchedRecFromAllObjs.addAll(fetchedTduRec);
            fetchedRecFromAllObjs.addAll(fetchedTagRec);
            if(opp.StageName=='Shipped to Customer'){
                currentNewOpp=opp;
                String allTagFieldsOfOpp =opp.Automobile_Tag_Details_1__c+'\n'+opp.Automobile_Tag_Details_2__c+'\n'+
                    						opp.Automobile_Tag_Details_3__c;                        
                List<String> names = allTagFieldsOfOpp.split('[\nnull]');           //for new lines and null values
                Integer len,index;
                for(String namesToEdit: names){
                    namesToEdit=namesToEdit.trim();
                    if(namesToEdit.length()>18){
                        namesToEdit=namesToEdit.substring(0, 18);
                    }
                    len=namesToEdit.length();
                    if(len>0){
                        if(namesToEdit.charAt(len-1)==13){
                            namesToEdit=namesToEdit.substring(0,len-1);
                        }
                    }
                    setOfUniqueSuccessInsOrUpRecNames.add(namesToEdit);
                    listOfRecNamesToInsert.add(namesToEdit);
                }
                setOfUniqueSuccessInsOrUpRecNames.remove('');                
                while(listOfRecNamesToInsert.contains('')== true){
                    index=listOfRecNamesToInsert.indexOf('');
                    listOfRecNamesToInsert.remove(index);
                }
            }                  
            else if(opp.StageName=='Return To HQ'){
                currentNewOpp=opp;
                String hqFieldOfOpp =opp.Return_To_HQ__c;
                if(hqFieldOfOpp!=null){
                    List<String> namesFromHq = hqFieldOfOpp.split('\n');
                    List<String> hQNamesList = new List<String>();
                    for(String eachNameFromHq : namesFromHq ){
                        eachNameFromHq=eachNameFromHq.trim();
                        if(eachNameFromHq.length()>18){
                            eachNameFromHq=eachNameFromHq.substring(0, 18); 
                        }
                        hQNamesList.add(eachNameFromHq);
                    }
                    for(SObject rec: fetchedRecFromAllObjs){
                        if(hQNamesList.contains((String)rec.get('Name'))){
                            if(rec.get('Account__c')==opp.Installation_Account__c){
                                rec.put('Account__c',opp.Shipment_Account__c);
                                setOfNamesFromTagsOrHqToUpdate.add((String)rec.get('Name'));
                                mapOfAllRecordsToUpdate.put((String)rec.get('Name'),rec);
                            }
                        }
                    }
                }
            }
            else if(opp.StageName=='Return To Customer'){
                currentNewOpp=opp;
                String allTagFieldsOfOpp =opp.Automobile_Tag_Details_1__c+'\n'+opp.Automobile_Tag_Details_2__c+'\n'+
                    opp.Automobile_Tag_Details_3__c;
                List<String> listOfNamesFromTags = allTagFieldsOfOpp.split('[\nnull]');
                if(opp.Automobile_Tag_Details_1__c!=null || opp.Automobile_Tag_Details_2__c!=null || opp.Automobile_Tag_Details_3__c!=null){
                    List<String> tagNamesList = new List<String>();
                    for(String eachNameFromTags : listOfNamesFromTags){
                        eachNameFromTags=eachNameFromTags.trim();
                        if(eachNameFromTags.length()>18){
                            eachNameFromTags=eachNameFromTags.substring(0, 18); 
                        }
                        tagNamesList.add(eachNameFromTags);
                        setOfUniqueSuccessInsOrUpRecNames.add(eachNameFromTags);
                    }
                    for(SObject rec: fetchedRecFromAllObjs){
                        if(tagNamesList.contains((String)rec.get('Name')) && rec.get('Account__c')==opp.Shipment_Account__c){                           
                            rec.put('Account__c',opp.Installation_Account__c);
                            setOfUniqueSuccessInsOrUpRecNames.remove((String)rec.get('Name'));
                            setOfNamesFromTagsOrHqToUpdate.add((String)rec.get('Name'));
                            mapOfAllRecordsToUpdate.put((String)rec.get('Name'),rec);                               
                        }
                    }
                    setOfUniqueSuccessInsOrUpRecNames.remove('');		//set contains names that exclude existing names
                }
            }
        }
        listOfRecNamesToInsert.addAll(setOfUniqueSuccessInsOrUpRecNames);
        if(listOfRecNamesToInsert.size()>0){
            OpportunityTriggerHelper.insertRecords(currentNewOpp,listOfRecNamesToInsert); 
        }
        setOfUniqueSuccessInsOrUpRecNames.addAll(setOfNamesFromTagsOrHqToUpdate);  //Again adding excluded names to the set
        List<SObject> listOfAllRecordsToInsert = new List<SObject>(); 
        listOfAllRecordsToInsert.addAll(setOfAllRecordsToInsert);     //This set is filled by insertRecords() method
        if(listOfAllRecordsToInsert.size()>0){
            insert listOfAllRecordsToInsert;				// Insert is Outside of all loops
        }
        if(!mapOfAllRecordsToUpdate.isEmpty()){
            update mapOfAllRecordsToUpdate.values();		//Insert is Outside of all loops  
        }
        if(listOfAllRecordsToInsert.size()>0 || !mapOfAllRecordsToUpdate.isEmpty() || listOfInvalidRecNames.size()>0 || listOfDuplicateRecNames.size()>0){
            OpportunityTriggerHelper.emailOwnerAboutShipment(currentNewOpp);
        }
    }
    
    /*
    *
    *   Purpose :   To insert related records of Opportunity when stage is in Shipped to Customer or Return to Customer.
    *               
    */
    public static void insertRecords(Opportunity opp,List<String> listOfRecNamesToInsert){
        //Checking for duplicates before insertion-
        Set<String> setOfUniqueInserts = new Set<String>();
        setOfUniqueInserts.addAll(listOfRecNamesToInsert);
        String substr='';
        List<String> listOfNamesToCompare= new List<String>();
        for(String eachName : listOfRecNamesToInsert){
            eachName=eachName.trim();
            if(eachName.length()>18){
                eachName=eachName.substring(0, 18);
            }
            listOfNamesToCompare.add(eachName);
        }
        for(SObject rec: fetchedRecFromAllObjs){
            String recordName=(String)rec.get('Name');
            if(listOfNamesToCompare.contains(recordName)){
                setOfUniqueSuccessInsOrUpRecNames.remove(recordName);
                setOfUniqueInserts.remove(recordName);
                listOfDuplicateRecNames.add(recordName);
            }
        }
        //checking done
        for(String eachName : setOfUniqueInserts){
            Automobile_Sensor__c sensorObj = new Automobile_Sensor__c();
            Automobile_Presence_Sensor__c prSensorObj= new Automobile_Presence_Sensor__c();
            Automobile_TDU__c tduObj = new Automobile_TDU__c();
            Automobile_Tag__c tagObj = new Automobile_Tag__c();
            if(eachName.length()>=3){       //To avoid out of bounds error
            	substr=eachName.substring(0,3); 
            }
            if(eachName.startsWith('00:11:CE:00')){
                sensorObj.Opportunity__c=opp.Id;
                sensorObj.Account__c=opp.Installation_Account__c;
                sensorObj.Name=eachName;
                setOfAllRecordsToInsert.add(sensorObj);
            }
            else if(eachName.startsWith('00:11:CE:D')){
                prSensorObj.Opportunity__c=opp.Id;
                prSensorObj.Account__c=opp.Installation_Account__c;
                prSensorObj.Name=eachName;
                setOfAllRecordsToInsert.add(prSensorObj);
            }
            else if(eachName.startsWith('00:11:CE:E')){
                tduObj.Opportunity__c=opp.Id;
                tduObj.Account__c=opp.Installation_Account__c;
                tduObj.Name=eachName;
                setOfAllRecordsToInsert.add(tduObj);
            }
            else if(substr.isNumeric() && eachName.substring(3,4)=='-'&& eachName.substring(7,8)=='-' && eachName.length()==11){
                tagObj.Opportunity__c=opp.Id;
                tagObj.Account__c=opp.Installation_Account__c;
                tagObj.Name=eachName;
                setOfAllRecordsToInsert.add(tagObj);
            }
            else{
                listOfInvalidRecNames.add(eachName);
            }
        }
    }
    
    /*
    *
    *   Purpose :   To send email to Opportunity owner when any successful/unsuccessful insertion or updation is made with details in table.
    *               
    */
    public static void emailOwnerAboutShipment(Opportunity oppNew){
        try{
            List<Messaging.SingleEmailMessage> emailObjects= new List<Messaging.SingleEmailMessage>();
            String body='Sensor shipment process is completed. Please refer below mentioned details to get all'+
                        ' the success and failure details.<br/><br/>';
            String messageColumn;
            Set<Id> setOfOppIds = new Set<Id>();                
            setOfOppIds.add(oppNew.Id);
            List<Automobile_Sensor__c> sensorRecs =[SELECT Name,Account__c,Opportunity__c FROM Automobile_Sensor__c WHERE
                                                        Opportunity__c IN: setOfOppIds AND Name IN: setOfUniqueSuccessInsOrUpRecNames];
            List<Automobile_Presence_Sensor__c> prSensorRecs =[SELECT Name,Account__c,Opportunity__c FROM Automobile_Presence_Sensor__c WHERE
                                                                Opportunity__c IN: setOfOppIds AND Name IN: setOfUniqueSuccessInsOrUpRecNames];
            List<Automobile_TDU__c> tduRecs =[SELECT Name,Account__c,Opportunity__c FROM Automobile_TDU__c WHERE
                                                Opportunity__c IN: setOfOppIds AND Name IN: setOfUniqueSuccessInsOrUpRecNames];
            List<Automobile_Tag__c> tagRecs =[SELECT Name,Account__c,Opportunity__c FROM Automobile_Tag__c WHERE 
                                                Opportunity__c IN: setOfOppIds AND Name IN: setOfUniqueSuccessInsOrUpRecNames];
            Account installationAcc=[SELECT Name FROM Account WHERE Id =: oppNew.Installation_Account__c];
            Account shipmentAcc=[SELECT Name FROM Account WHERE Id =: oppNew.Shipment_Account__c];
            List<SObject> fetchedRecords = new List<SObject>();
            fetchedRecords.addAll(sensorRecs);
            fetchedRecords.addAll(prSensorRecs);
            fetchedRecords.addAll(tduRecs);
            fetchedRecords.addAll(tagRecs);
            List<SObject> updatedRecords = new List<SObject>();
            updatedRecords.addAll(mapOfAllRecordsToUpdate.values());
            Map<String, String> messageWithRecName = new Map<String, String>();
            for( SObject fetchedRec : fetchedRecords){
                for(SObject updatedRec : updatedRecords){
                    if(updatedRec==fetchedRec){
                        if(oppNew.StageName=='Return To Customer'){
                            messageColumn=' is moved from shipment account '+shipmentAcc.Name+' to installation account '+
                                installationAcc.Name+' .';
                            messageWithRecName.put((String)fetchedRec.get('Name'),messageColumn);
                        }                            
                        else if(oppNew.StageName=='Return To HQ'){
                            messageColumn=' is moved from installation account '+installationAcc.Name+' to shipment account '+
                                shipmentAcc.Name+' .';
                            messageWithRecName.put((String)fetchedRec.get('Name'),messageColumn);
                        } 
                        break;
                    }
                }
                for(SObject insertedRecNames :setOfAllRecordsToInsert){
                    if(fetchedRec==insertedRecNames){
                        if(oppNew.StageName=='Shipped to Customer' || oppNew.StageName=='Return To Customer' ){
                            messageColumn=' inserted under installation account '+installationAcc.Name;
                            messageWithRecName.put((String)fetchedRec.get('Name'),messageColumn);
                        }
                    }
                }                    
            }
            if(messageWithRecName.size()>0){
                body+='<b>Successful:</b><br/><br/><table border=1 cellpadding=5 cellspacing=0><tr><th align=left>'+
                'Automobile Type</th><th align=left>Name</th><th align=left>Message</th></tr>';
                for(Automobile_Sensor__c sensor :sensorRecs){
                    body+='<tr><td>Sensor</td><td>'+sensor.Name+'</td><td>Sensor'+messageWithRecName.get(sensor.Name)+'</td></tr>';
                }
                for(Automobile_Presence_Sensor__c prSensor :prSensorRecs){
                    body+='<tr><td>Presence Sensor</td><td>'+prSensor.Name+'</td><td>Presence Sensor'+messageWithRecName.get(prSensor.Name)+'</td></tr>';
                }
                for(Automobile_TDU__c tdu :tduRecs){
                    body+='<tr><td>TUD</td><td>'+tdu.Name+'</td><td>TUD'+messageWithRecName.get(tdu.Name)+'</td></tr>';
                }
                for(Automobile_Tag__c tag :tagRecs){
                    body+='<tr><td>Tag</td><td>'+tag.Name+'</td><td>Tag'+messageWithRecName.get(tag.Name)+'</td></tr>';
                }
                body+='</table><br/><br/>';
            }
            if(listOfInvalidRecNames.size()>0 || listOfDuplicateRecNames.size()>0){
                body+='<b>Unsuccessful:</b><br/><br/><table border=1 cellpadding=5 cellspacing=0><tr><th align=left>'+
                'Automobile Type</th><th align=left>Name</th><th align=left>Message</th></tr>';
                for(String invalidName : listOfInvalidRecNames){
                    body+='<tr><td>Sensor</td><td>'+invalidName+'</td><td>Invalid Sensor</td></tr>';
                }
                for(Automobile_Sensor__c sensor :fetchedSensorRec){
                    if(listOfDuplicateRecNames.contains(sensor.Name)){
                        body+='<tr><td>Sensor</td><td>'+sensor.Name+'</td><td>Sensor '+
                                'can\'t be inserted under installation account '+installationAcc.Name+
                                ' b/c it is already under '+
                            (sensor.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                    }
                }
                for(Automobile_Presence_Sensor__c prSensor :fetchedPrSensorRec){
                    if(listOfDuplicateRecNames.contains(prSensor.Name)){
                        body+='<tr><td>Presence Sensor</td><td>'+prSensor.Name+'</td><td>Presence Sensor '+
                                'can\'t be inserted under installation account '+installationAcc.Name+
                                ' b/c it is already under '+
                            (prSensor.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                    }
                }
                for(Automobile_TDU__c tdu :fetchedTduRec){
                    if(listOfDuplicateRecNames.contains(tdu.Name)){
                        body+='<tr><td>TUD</td><td>'+tdu.Name+'</td><td>TUD '+
                                'can\'t be inserted under installation account '+installationAcc.Name+
                                ' b/c it is already under '+
                            (tdu.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                    }
                }
                for(Automobile_Tag__c tag :fetchedTagRec){
                    if(listOfDuplicateRecNames.contains(tag.Name)){
                        body+='<tr><td>Tag</td><td>'+tag.Name+'</td><td>Tag '+
                                'can\'t be inserted under installation account '+installationAcc.Name+
                                ' b/c it is already under '+
                            (tag.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                    }
                }
                body+='</table>';
            }
            Messaging.SingleEmailMessage emailObj = new Messaging.SingleEmailMessage();
            List<String> emailAddresses = new List<String>();
            Opportunity oppToFindOwner=[SELECT Name, OwnerId FROM Opportunity WHERE Id =: oppNew.Id];
            Id ownersId=oppToFindOwner.OwnerId;
            User userOfTheNewOpp=[SELECT Name,Email FROM User WHERE Id=: ownersId];   //Fetching email of opp owner
            emailAddresses.add(userOfTheNewOpp.Email);
            emailObj.setToAddresses(emailAddresses);
            emailObj.setSubject(oppNew.Name+' + Shipment Details '+date.today().format());                
            emailObj.setHtmlBody(body);
            emailObjects.add(emailObj);
            System.debug('Changed3');            
            Messaging.sendEmail(emailObjects);     
        }catch(Exception e){
            System.debug('Daily mailing limit is 15 , see error message-> '+e.getMessage());
        }
    }
}