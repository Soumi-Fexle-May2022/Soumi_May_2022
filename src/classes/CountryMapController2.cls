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
public class CountryMapController2 {
    List<String> districtList=new List<String>();
    List<String> distList=new List<String>();
    Map<String,List<String>> mapOfDistrictsWithState = new Map<String,List<String>>();
    Map<String,List<String>> distsStateMap = new Map<String,List<String>>();
    Map<String, Map<String,List<String>>> mapOfStatesWithCountry = new  Map<String, Map<String,List<String>>>();
    String lt;
    public CountryMapController2(String letter) {
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
        System.debug('Combination of Country State District that starts with "'+letter+'" using DML:-');
        getCombinationStartsWith(lt);
        System.debug('Combination of Country State District that starts with "'+letter+'" using Maps:-');
        getCombinationStartsWithUsingMap(letter);
        System.debug('Districts with length more than 10 :-');
        getMaxLengthDist();
    }

    /*
    *
    *   Purpose :   Finds a combination of related Country, State, City which begins with "S" using DML
    *
    */
    public void getCombinationStartsWith(String lt){
        List<District__c> districts = [SELECT Name, State__r.Name, State__r.Country__r.Name,State__r.Country__r.Country_JSON_Data__c FROM District__c WHERE  State__r.Country__r.Name LIKE: lt AND State__r.Name LIKE: lt AND Name LIKE: lt];
        Country_MapController2.Country obj= new Country_MapController2.Country();
        if(districts.isEmpty())
            System.debug('No Country-State-District combination was found');
        else{
            for(District__c d : districts){
                System.debug(d.State__r.Country__r.Name+' -> '+d.State__r.Name+' -> '+d.name);
            }
        }    
    }

    /*
    *
    *   Purpose :   Finds a combination of related Country, State, City which begins with "S" using maps
    *
    */
    public void getCombinationStartsWithUsingMap(String lt){
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
    }

    /*
    *
    *   Purpose :   Finds those districts with length more than 10
    *
    */
    public void getMaxLengthDist(){
        List<String> distNames = new List<String>();
        List<District__c> districtList = [SELECT Name FROM District__c WHERE Name LIKE '__________%'];
        for(District__c dist : districtList)
            distNames.add(dist.Name);
        System.debug(distNames);
    }

    /*
    *
    *   Purpose :   Creates JSON data of Country-State-District data for that Country that has State and District with
    *               same entered letter using DML
    *
    */
    
    public void countryJSONGenerator(String conName) {
        District__c d=[SELECT Name, State__r.Name, State__r.Country__r.Name,State__r.Country__r.Country_Code__c,
        State__r.Country__r.Total_States__c,State__r.Country__r.Total_Districts__c,
        State__r.Country__r.Country_JSON_Data__c FROM District__c 
        WHERE  State__r.Country__r.Name =: conName AND State__r.Name LIKE: lt AND Name LIKE: lt limit 1];

        CountryMapController2.Country obj= new CountryMapController2.Country();
        obj.countryName=conName;
        obj.countryCode=d.State__r.Country__r.Country_Code__c;
        obj.totalStatesNumber=d.State__r.Country__r.Total_States__c;
        obj.totalDistricts=d.State__r.Country__r.Total_Districts__c;

        CountryMapController2.State obj2= new CountryMapController2.State();
        obj2.stateName=d.State__r.Name;

        CountryMapController2.District obj3= new CountryMapController2.District();
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