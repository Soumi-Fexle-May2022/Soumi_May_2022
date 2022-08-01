/*
* 	Description		:	To insert, update related records for Opportunity under its 4 child objects, and to send email to owner.
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	29/07/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 29/07/2022 
* 
* */
public class OpportunityTriggerHelper {
    Set<SObject> setOfAllRecordsToInsert = new Set<SObject>();
    List<SObject> listOfAllRecordsToInsert = new List<SObject>();            
    Map<String,SObject> mapOfAllRecordsToUpdate = new Map<String,SObject>();
    Set<String> setOfNamesFromTagsOrHqToUpdate = new Set<String>();
    Set<String> setOfUniqueSuccessInsOrUpRecNames=new Set<String>();
    Set<String> setOfUniqueInserts = new Set<String>();
    List<String> listOfDuplicateRecNames = new List<String>();
    List<String> listOfInvalidRecNames = new List<String>();
    String substr='';
    List<Automobile_Sensor__c> fetchedSensorRec =[SELECT Name,Opportunity__c,Account__c FROM Automobile_Sensor__c];
    List<Automobile_Presence_Sensor__c> fetchedPrSensorRec=[SELECT Name,Opportunity__c,Account__c FROM Automobile_Presence_Sensor__c];
    List<Automobile_TDU__c> fetchedTduRec =[SELECT Name,Opportunity__c,Account__c FROM Automobile_TDU__c];
    List<Automobile_Tag__c> fetchedTagRec =[SELECT Name,Opportunity__c,Account__c FROM Automobile_Tag__c];
    List<SObject> fetchedRecFromAllObjs = new List<SObject>();
    public OpportunityTriggerHelper(){
        fetchedRecFromAllObjs.addAll(fetchedSensorRec);
        fetchedRecFromAllObjs.addAll(fetchedPrSensorRec);
        fetchedRecFromAllObjs.addAll(fetchedTduRec);
        fetchedRecFromAllObjs.addAll(fetchedTagRec); 
    }
    
    /*
    *
    *   Purpose :   To insert or update related records of Opportunity when stage is in Shipped to Customer or Return to HQ or
    *               Return to Customer.
    *
    */
    public void populateChildObjRecords(List<Opportunity> newOppsList, List<Opportunity> oldOppsList){  
        for(Opportunity opp : newOppsList){  
            //Refreshing the instance variables for each new opportunity-
            setOfAllRecordsToInsert.clear();
            listOfAllRecordsToInsert.clear();            
            mapOfAllRecordsToUpdate.clear();
            setOfNamesFromTagsOrHqToUpdate.clear();
            setOfUniqueSuccessInsOrUpRecNames.clear();
            setOfUniqueInserts.clear();
            listOfDuplicateRecNames.clear();
            listOfInvalidRecNames.clear();
            if(opp.StageName=='Shipped to Customer'){
                String allTagFieldsOfOpp =opp.Automobile_Tag_Details_1__c+'\n'+opp.Automobile_Tag_Details_2__c+'\n'+
                    						opp.Automobile_Tag_Details_3__c;
                List<String> names = allTagFieldsOfOpp.split('[\nnull]');
                List<String> listOfRecNamesToInsert= new List<String>();
                Integer len,index;
                for(String namesToEdit: names){
                    namesToEdit=namesToEdit.trim();
                    if(namesToEdit.length()>18){
                        namesToEdit=namesToEdit.substring(0, 18);
                    }
                    len=namesToEdit.length();
                    if(len>0){
                        if(namesToEdit.charAt(len-1)==13)
                            namesToEdit=namesToEdit.substring(0,len-1);
                    }
                    setOfUniqueSuccessInsOrUpRecNames.add(namesToEdit);
                    listOfRecNamesToInsert.add(namesToEdit);
                }
                setOfUniqueSuccessInsOrUpRecNames.remove('');                
                while(listOfRecNamesToInsert.contains('')== true){
                    index=listOfRecNamesToInsert.indexOf('');
                    listOfRecNamesToInsert.remove(index);
                }
                if(listOfRecNamesToInsert.size()>0){
                	insertRecords(opp,listOfRecNamesToInsert); 
                }
            }                  
            else if(opp.StageName=='Return To HQ'){
                String hqFieldOfOpp =opp.Return_To_HQ__c;
                if(hqFieldOfOpp!=null){
                    List<String> namesFromHq = hqFieldOfOpp.split('\n');
                    for(String eachNameFromHq : namesFromHq ){
                        eachNameFromHq=eachNameFromHq.trim();
                        if(eachNameFromHq.length()>18){
                            eachNameFromHq=eachNameFromHq.substring(0, 18); 
                        }
                        for(SObject rec: fetchedRecFromAllObjs){
                            String typeOfSobject = rec.getSObjectType().getDescribe().getName();
                            if((typeOfSobject=='Automobile_Sensor__c' || typeOfSobject=='Automobile_Presence_Sensor__c' ||
                                typeOfSobject=='Automobile_TDU__c' || typeOfSobject=='Automobile_Tag__c')&&
                               eachNameFromHq==rec.get('Name')){
                                   if(rec.get('Account__c')==opp.Installation_Account__c){
                                       rec.put('Account__c',opp.Shipment_Account__c);
                                       setOfNamesFromTagsOrHqToUpdate.add(eachNameFromHq);
                                       mapOfAllRecordsToUpdate.put(eachNameFromHq,rec);
                                   }
                            }
                        }
                    }
                }
            }
            else if(opp.StageName=='Return To Customer'){
                String allTagFieldsOfOpp =opp.Automobile_Tag_Details_1__c+'\n'+opp.Automobile_Tag_Details_2__c+'\n'+
                    opp.Automobile_Tag_Details_3__c;
                List<String> listOfNamesFromTags = allTagFieldsOfOpp.split('[\nnull]');
                List<String> listOfRecNamesToInsert = new List<String>();
                for(String eachNameFromTags : listOfNamesFromTags){
                    eachNameFromTags=eachNameFromTags.trim();
                    if(eachNameFromTags.length()>18){
                        eachNameFromTags=eachNameFromTags.substring(0, 18); 
                    }
                    setOfUniqueSuccessInsOrUpRecNames.add(eachNameFromTags);
                    for(SObject rec: fetchedRecFromAllObjs){
                        String typeOfSobject = rec.getSObjectType().getDescribe().getName();
                        if((typeOfSobject=='Automobile_Sensor__c' || typeOfSobject=='Automobile_Presence_Sensor__c' ||
                            typeOfSobject=='Automobile_TDU__c' || typeOfSobject=='Automobile_Tag__c')&&
                           eachNameFromTags==rec.get('Name') && rec.get('Account__c')==opp.Shipment_Account__c){                           
                               rec.put('Account__c',opp.Installation_Account__c);
                               setOfUniqueSuccessInsOrUpRecNames.remove(eachNameFromTags);
                               setOfNamesFromTagsOrHqToUpdate.add(eachNameFromTags);
                               mapOfAllRecordsToUpdate.put(eachNameFromTags,rec);                               
                           }
                    }
                }
                setOfUniqueSuccessInsOrUpRecNames.remove('');		//set contains names that exclude existing names
                listOfRecNamesToInsert.addAll(setOfUniqueSuccessInsOrUpRecNames);
                if(listOfRecNamesToInsert.size()>0){
                	insertRecords(opp,listOfRecNamesToInsert);      //list contains names that exclude existing names
                }
            }
            setOfUniqueSuccessInsOrUpRecNames.addAll(setOfNamesFromTagsOrHqToUpdate);  //Again adding excluded names to the set
        }
        listOfAllRecordsToInsert.addAll(setOfAllRecordsToInsert);     //This set is filled by insertRecords() method
        if(listOfAllRecordsToInsert.size()>0){
            insert listOfAllRecordsToInsert;				// Insert is Outside of all loops
        }
        if(!mapOfAllRecordsToUpdate.isEmpty()){
            update mapOfAllRecordsToUpdate.values();		//Insert is Outside of all loops  
        }
        emailOwnerAboutShipment(newOppsList);
    }
    
    /*
    *
    *   Purpose :   To insert related records of Opportunity when stage is in Shipped to Customer or Return to Customer.
    *               
    */
    public void insertRecords(Opportunity opp,List<String> listOfRecNamesToInsert){
        //Checking for duplicates before insertion-
        setOfUniqueInserts.addAll(listOfRecNamesToInsert);
        for(String eachName : listOfRecNamesToInsert){
            eachName=eachName.trim();
            if(eachName.length()>18){
                eachName=eachName.substring(0, 18);
            }
            for(SObject rec: fetchedRecFromAllObjs){
                String typeOfSobject = rec.getSObjectType().getDescribe().getName();
                String recordName=(String)rec.get('Name');
                if((typeOfSobject=='Automobile_Sensor__c' || typeOfSobject=='Automobile_Presence_Sensor__c' ||
                    typeOfSobject=='Automobile_TDU__c' || typeOfSobject=='Automobile_Tag__c')&&
                   eachName==recordName){
                       setOfUniqueSuccessInsOrUpRecNames.remove(eachName);
                       setOfUniqueInserts.remove(eachName);
                       listOfDuplicateRecNames.add(eachName);
                 }
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
    public void emailOwnerAboutShipment(List<Opportunity> newOppsList){
        try{
            List<Messaging.SingleEmailMessage> emailObjects= new List<Messaging.SingleEmailMessage>();
            String body='Sensor shipment process is completed. Please refer below mentioned details to get all'+
                		' the success and failure details.<br/><br/>';
            String messageColumn;
            for(Opportunity oppNew: newOppsList){
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
                	body+='<b>Unsuccessfull:</b><br/><br/><table border=1 cellpadding=5 cellspacing=0><tr><th align=left>'+
					'Automobile Type</th><th align=left>Name</th><th align=left>Message</th></tr>';
                    for(String invalidName : listOfInvalidRecNames){
                    	body+='<tr><td>Sensor</td><td>'+invalidName+'</td><td>Invalid Sensor</td></tr>';
                    }
                    for(String duplicateAccName : listOfDuplicateRecNames){
                        for(Automobile_Sensor__c sensor :fetchedSensorRec){
                            if(duplicateAccName==sensor.Name){
                            	body+='<tr><td>Sensor</td><td>'+duplicateAccName+'</td><td>Sensor '+
                                		'can\'t be inserted under installation account '+installationAcc.Name+
                                    	' b/c it is already under '+
                                    (sensor.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                            }
                        }
                        for(Automobile_Presence_Sensor__c prSensor :fetchedPrSensorRec){
                            if(duplicateAccName==prSensor.Name){
                            	body+='<tr><td>Presence Sensor</td><td>'+duplicateAccName+'</td><td>Presence Sensor '+
                                		'can\'t be inserted under installation account '+installationAcc.Name+
                                    	' b/c it is already under '+
                                    (prSensor.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                            }
                        }
                        for(Automobile_TDU__c tdu :fetchedTduRec){
                            if(duplicateAccName==tdu.Name){
                            	body+='<tr><td>TUD</td><td>'+duplicateAccName+'</td><td>TUD '+
                                		'can\'t be inserted under installation account '+installationAcc.Name+
                                    	' b/c it is already under '+
                                    (tdu.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                            }
                        }
                        for(Automobile_Tag__c tag :fetchedTagRec){
                            if(duplicateAccName==tag.Name){
                            	body+='<tr><td>Tag</td><td>'+duplicateAccName+'</td><td>Tag '+
                                		'can\'t be inserted under installation account '+installationAcc.Name+
                                    	' b/c it is already under '+
                                    (tag.Account__c==installationAcc.Id ? installationAcc.Name : shipmentAcc.Name)+' account.</td></tr>';
                            }
                        }
                    }
                    body+='</table>';
            	}
                if(oppNew.StageName=='Prospect' || oppNew.StageName=='Qualification' || oppNew.StageName=='Processing'){
                    body+='No record was inserted as stage is '+oppNew.StageName+' .';
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
            }
            Messaging.sendEmail(emailObjects);     
        }catch(Exception e){
            System.debug('Daily mailing limit is 15 , see error message-> '+e.getMessage());
        }
    }
}