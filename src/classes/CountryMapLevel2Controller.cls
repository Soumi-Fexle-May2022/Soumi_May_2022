/*
 * 	Description		:	To understand hierarchichal collections by retrieving record data from Custom Object records 
 *                      from a hierarchically related country-state-district object and to update a custom field using JSON
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	07/07/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 07/07/2022
 * */
public class CountryMapLevel2Controller {
    List<String> districtList=new List<String>();
    List<String> distList=new List<String>();
    Map<String,List<String>> mapOfDistrictsWithState = new Map<String,List<String>>();
    Map<String,List<String>> distsStateMap = new Map<String,List<String>>();
    Map<String, Map<String,List<String>>> mapOfStatesWithCountry = new  Map<String, Map<String,List<String>>>();
    String lt;
    public CountryMapLevel2Controller(String letter) {
        try{
            lt=letter+'%';
            for(Country__c con :[SELECT Name FROM Country__c]){
                for(State__c st: [SELECT Name FROM State__c WHERE Country__r.Name =: con.Name]){
                    for(District__c dist: [SELECT Name FROM District__c WHERE State__r.Name =: st.Name]){
                        districtList.add(dist.Name);
                    }
                    distList=districtList.clone();
                    mapOfDistrictsWithState.put(st.Name, distList); 
                    districtList.clear();              
                }
                distsStateMap=mapOfDistrictsWithState.clone();
                mapOfStatesWithCountry.put(con.Name,distsStateMap);
                mapOfDistrictsWithState.clear();
            }
            System.debug('Records of Country-State-District retrieved from org :- ');
            System.debug(mapOfStatesWithCountry);
            fillTotalStatesTotalDists();
            System.debug('Filled up the total districts field of State object');
            System.debug('Filled up the total states , total districts fields of Country object');
            System.debug('Combination of Country State District that starts with "'+letter+'" using DML:-');
            getCombinationStartsWith(lt);
            System.debug('Combination of Country State District that starts with "'+letter+'" using Maps:-');
            getCombinationStartsWithUsingMap(letter);
            System.debug('Districts with length more than 10 :-');
            getMaxLengthDist();
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage());
        }
    }

    /*
    *
    *   Purpose :   To update Total States and Total District fields of Country Object
    *               and to update Total District field of State Object
    *
    */
    public void fillTotalStatesTotalDists(){
        try{
            //First Updating the field of State Object
            List<State__c> stsList=[SELECT Name,Total_Districts_Number__c FROM State__c];
            List<State__c> statesToUpdate= new List<State__c>();
            List<State__c>  defaultTotDis= new List<State__c>();
            update statesToUpdate;
            for(State__c st: stsList){
                st.Total_Districts_Number__c=0;
                defaultTotDis.add(st);
            }update defaultTotDis;      //Setting the default value of Total Districts as 0

            List<AggregateResult> dis=[SELECT State__r.Id,COUNT(Name) totDists FROM District__c GROUP BY State__r.Id];
            for(State__c st: stsList){
                for(AggregateResult result: dis){
                    if(st.Id==(Id)result.get('Id')){
                        st.Total_Districts_Number__c=(Integer)result.get('totDists');
                        statesToUpdate.add(st);
                    }
                }
            }update statesToUpdate;     //Updates Total Districts for those states that have atleast 1 district.

            //Now Updating the fields of Country Object
            List<Country__c> conList= [SELECT Name,Total_States__c,Total_Districts__c FROM Country__c];
            List<Country__c> countriesToUpdate= new List<Country__c>();
            List<Country__c> defTotDisStates= new List<Country__c>();
            for(Country__c con: conList){
                con.Total_States__c=0;
                con.Total_Districts__c=0;
                defTotDisStates.add(con);
            }update defTotDisStates;       //Setting the default value of Total States and Total Districts as 0

            List<AggregateResult> st=[SELECT Country__r.Id,COUNT(Name) totSts, SUM(Total_Districts_Number__c) totDis FROM State__c GROUP BY Country__r.Id];
            for(Country__c con: conList){
                for(AggregateResult r: st){ 
                    if(con.Id==(Id)r.get('Id')){
                        con.Total_States__c=(Integer)r.get('totSts');
                        con.Total_Districts__c=(Decimal)r.get('totDis');
                        countriesToUpdate.add(con);
                    }
                }
            }update countriesToUpdate;    //Updates Total States and Total Districts for those countries that have atleast 1 state or 1 dist.
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage());
        }
    }

    /*
    *
    *   Purpose :   Finds a combination of related Country, State, City which begins with "S" using DML
    *
    */
    public void getCombinationStartsWith(String lt){
        try{
            List<District__c> districts = [SELECT Name, State__r.Name, State__r.Country__r.Name,State__r.Country__r.Country_JSON_Data__c FROM District__c WHERE  State__r.Country__r.Name LIKE: lt AND State__r.Name LIKE: lt AND Name LIKE: lt];
            if(districts.isEmpty())
                System.debug('No Country-State-District combination was found');
            else{
                for(District__c d : districts){
                    System.debug(d.State__r.Country__r.Name+' -> '+d.State__r.Name+' -> '+d.name);
                }
            } 
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage());
        }  
    }

    /*
    *
    *   Purpose :   Finds a combination of related Country, State, City which begins with "S" using maps
    *
    */
    public void getCombinationStartsWithUsingMap(String lt){
        try{
            Boolean found=false;
            for(String con : mapOfStatesWithCountry.keySet()){
                if(con.startsWith(lt)){
                    for(Map<String,List<String>> state_districts : mapOfStatesWithCountry.values()){
                        for(String state : state_districts.keySet()){
                            if(state.startsWith(lt)){
                                for(List<String> districtsList: state_districts.values()){
                                    for(String dist: districtsList){
                                        if(dist.startsWith(lt)){
                                            System.debug(con+' -> '+state+' -> '+dist);
                                            found=true;
                                            countryJSONGenerator(con);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if(found== false){System.debug('No Country-State-District combination was found');}
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage());
        }
    }

    /*
    *
    *   Purpose :   Finds those districts with length more than 10
    *
    */
    public void getMaxLengthDist(){
        try{
            List<String> distNames = new List<String>();
            List<District__c> districtList = [SELECT Name FROM District__c WHERE Name LIKE '__________%'];
            for(District__c dist : districtList)
                distNames.add(dist.Name);
            System.debug(distNames);
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage());
        }
    }

    /*
    *
    *   Purpose :   Creates JSON data of Country-State-District data for that Country that has State and District with
    *               same entered letter using DML
    *
    */
    
    public void countryJSONGenerator(String conName) {
        try{
        District__c d=[SELECT Name, State__r.Name, State__r.Country__r.Name,State__r.Country__r.Country_Code__c,
        State__r.Country__r.Total_States__c,State__r.Country__r.Total_Districts__c,
        State__r.Country__r.Country_JSON_Data__c FROM District__c 
        WHERE  State__r.Country__r.Name =: conName AND State__r.Name LIKE: lt AND Name LIKE: lt limit 1];

        CountryMapLevel2Controller.Country obj= new CountryMapLevel2Controller.Country();
        obj.countryName=conName;
        obj.countryCode=d.State__r.Country__r.Country_Code__c;
        obj.totalStatesNumber=d.State__r.Country__r.Total_States__c;
        obj.totalDistricts=d.State__r.Country__r.Total_Districts__c;

        CountryMapLevel2Controller.State obj2= new CountryMapLevel2Controller.State();
        obj2.stateName=d.State__r.Name;

        CountryMapLevel2Controller.District obj3= new CountryMapLevel2Controller.District();
        obj3.districtName=d.Name;

        /*
        *
        *   Purpose :    To format the JSON data into given format we are using map
        *
        */
        Map<String, Object> combinationMap = new Map<String, Object>();
        Map<String, Object> countryMap = new Map<String, Object>();               
        Map<String, Object> stateMap = new Map<String, Object>();
        Map<String, Object> distMap = new Map<String, Object>();
        distMap.put('District Name', obj3.districtName);
        stateMap.put('District',distMap);
        stateMap.put('State Name', obj2.stateName);
        countryMap.put('State', stateMap);
        countryMap.put('Total Districts', obj.totalDistricts );
        countryMap.put('Total States Number', obj.totalStatesNumber );
        countryMap.put('Country Code', obj.countryCode);
        countryMap.put('Country Name', obj.countryName);
        combinationMap.put('Country',countryMap);
        d.State__r.Country__r.Country_JSON_Data__c=JSON.SerializePretty(combinationMap);
        update d.State__r.Country__r;  
        System.debug('Updated the Country JSON Data field for the Country '+obj.countryName);
        }catch(Exception e){
            System.debug('Error -> '+e.getMessage());
        }
    } 
    public class State{
        public String stateName{get; set;}
    }
    public class District{
        public String districtName{get; set;}
    }   
    public class Country{
        public String countryName{get; set;}
        public String countryCode{get; set;}
        public Decimal totalStatesNumber{get; set;}
        public Decimal totalDistricts{get; set;}
    }    
}