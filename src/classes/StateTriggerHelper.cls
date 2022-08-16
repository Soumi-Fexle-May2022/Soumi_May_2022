/*
* 	Description		:	To populate total states field, total districts field and Country Json Data field in Country Object
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	08/08/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 08/08/2022 
* 
* */
public class StateTriggerHelper {

    /*
    *
    *   Purpose :   Feteches the Country IDs of the states that are modified(insert/update/delete/undelete) and then uses this IDs to
    * 				populate the total number of states field in Country obj when a related state is inserted/updated/deleted/undeleted.
    *
    */
    public static void populateNumOfStatesOnCountry(List<State__c> stateListNew,List<State__c> stateListOld){
        Set<Id> setOfCountryIds=new Set<Id>();
        Set<Id> setOfStateIds=new Set<Id>();
        for(State__c st : stateListNew != null ? stateListNew : stateListOld){
            setOfCountryIds.add(st.Country__c);
            setOfStateIds.add(st.Id);
        }
        //Adding those Country Ids which were in a state record before an update
        //So that we can update the fields of the old Parent Country of a state after an update
        if(stateListOld !=null){
            for(State__c st : stateListOld){
                setOfCountryIds.add(st.Country__c);
                setOfStateIds.add(st.Id);
            }
        }
        List<AggregateResult> groupedResultFromState =[SELECT Country__c, COUNT(Id) totStates,SUM(Total_Districts_Number__c) totDis FROM State__c 
                                                        WHERE Country__c IN: setOfCountryIds GROUP BY Country__c];
        Set<Id> IdOfStatesFromResult = new  Set<Id>();                                       
        Set<Country__c> setOfCountryToUpdate = new Set<Country__c>();
        List<Country__c> listOfCountryToUpdate = new List<Country__c>();
        List<Country__c> countryList =[SELECT Id, Name FROM Country__c WHERE Id IN: setOfCountryIds];    
        Map<Id,AggregateResult> mapOfAggregateResult = new Map<Id,AggregateResult>();                                                                        
        for(AggregateResult result: groupedResultFromState){
            IdOfStatesFromResult.add((Id)result.get('Country__c'));            
            mapOfAggregateResult.put((Id)result.get('Country__c'),result);
        }
        for(Country__c country : countryList){
            if(mapOfAggregateResult.containsKey(country.Id)){
                AggregateResult result = mapOfAggregateResult.get(country.Id);
                country.Total_States__c=(Integer)result.get('totStates');
                country.Total_Districts__c=(Decimal)result.get('totDis');
                setOfCountryToUpdate.add(country);
            }
        }
        //This list contains those Country Ids that dont have any related state
        //We made this list seperately as Aggregate result could not count 0 for no related states.
        List<Country__c> counList=[SELECT Id FROM Country__c WHERE (Id IN: setOfCountryIds AND Id NOT IN: IdOfStatesFromResult)];
        for(Country__c country: counList){
            country.Total_States__c=0;         //No related state
            setOfCountryToUpdate.add(country);
        }
        listOfCountryToUpdate.addAll(setOfCountryToUpdate);
        if(listOfCountryToUpdate.size()>0){
            update listOfCountryToUpdate;
        }
        //For updating ---> Country JSON Data
        if(setOfCountryToUpdate.size()>0){
            StateTriggerHelper.populateCountryJSONData(setOfCountryIds);
        }
    }

   /*
    *
    *   Purpose :   Populates the Country JSON data field when state record is inserted, updated, deleted or undeleted.
    *
    */
    public static void populateCountryJSONData(Set<Id> setOfCountryIds){
        Map<String, Object> combinationMap = new Map<String, Object>();
        Map<String, Object> countryMap = new Map<String, Object>();               
        Map<String, Object> stateMap = new Map<String, Object>();
        Map<String, Object> distMap = new Map<String, Object>();
        Map<String, Object> clonedDistMap = new Map<String, Object>();
        List<Country__c> countriesList =[SELECT Name,Country_Code__c,Total_States__c,Total_Districts__c,Country_JSON_Data__c FROM Country__c 
                                    WHERE Id IN: setOfCountryIds];
        List<State__c> statesSet = [SELECT Country__c, Name, State_Code__c FROM State__c WHERE Country__c IN: setOfCountryIds];
        List<District__c> distSet =[SELECT State__c, Name FROM District__c];
        Set<String> setOfDistricts= new Set<String>();
        Map<String,Set<String>> mapOfDistrictsWithState=new Map<String,Set<String>>();
        Set<String> setOfDists= new Set<String>();
        Set<String> setOfStates= new Set<String>();
        for(Country__c country: countriesList){
            for(State__c st: statesSet){
                if(country.Id==st.Country__c){
                    for(District__c dist: distSet){
                        if(st.Id==dist.State__c){
                            setOfDists.add(dist.Name);                        
                        }
                    }
                    setOfDistricts=setOfDists.clone();
                    mapOfDistrictsWithState.put(st.Name,setOfDistricts);
                    distMap.put('District Name of State '+st.State_Code__c,mapOfDistrictsWithState.get(st.Name));
                    clonedDistMap=distMap.clone();
                    stateMap.put('District of '+st.State_Code__c,clonedDistMap);
                    setOfStates=mapOfDistrictsWithState.keySet().clone();
                    stateMap.put('State Name '+st.State_Code__c, setOfStates); 
                    distmap.clear();
                    mapOfDistrictsWithState.remove(st.Name);
                    setOfDists.clear();
                }
            }
            countryMap.put('State', stateMap);
            countryMap.put('Total Districts', country.Total_Districts__c );
            countryMap.put('Total States Number', country.Total_States__c);
            countryMap.put('Country Code', country.Country_Code__c);
            countryMap.put('Country Name', country.Name);
            combinationMap.put('Country',countryMap);
            country.Country_JSON_Data__c=JSON.SerializePretty(combinationMap);
            clonedDistMap.clear();
            distMap.clear();
            stateMap.clear();
            countryMap.clear();
            combinationMap.clear();
        }
        if(countriesList.size()>0){
            update countriesList;
        }
    }
}