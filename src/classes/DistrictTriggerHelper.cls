/*
* 	Description		:	To populate total districts field and State Json Data field in State Object and
*                       to populate total districts field and Country Json Data field in Country Object
* 
*   Created By		:	Soumi Chakraborty
* 
* 	Created Date	:	08/08/2022
* 
* 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 08/08/2022 
* 
* */
public class DistrictTriggerHelper {

    /*
    *
    *   Purpose :   Feteches the State IDs of the districts that are modified(insert/update/delete/undelete) and then uses this IDs to
    * 				populate the total number of districts field in State object and Country object when a related district is
    *               inserted/updated/deleted/undeleted.
    *
    */
    public static void populateNumOfDistrictsOnStateAndCountry(List<District__c> districtListNew,List<District__c> districtListOld){
        Set<Id> setOfStateIds=new Set<Id>();
        for(District__c dist : districtListNew != null ? districtListNew : districtListOld){
            setOfStateIds.add(dist.State__c);
        }
        //Adding those State Ids which were in a district record before an update
        //So that we can update the fields of the old Parent State of a District after an update
        if(districtListOld !=null){
            for(District__c dist : districtListOld){
                setOfStateIds.add(dist.State__c);
            }
        }
        List<AggregateResult> groupedResultFromDist =[SELECT State__c, COUNT(Id) totDists FROM District__c WHERE State__c IN: setOfStateIds
                                                GROUP BY State__c];
        Set<Id> IdOfDistsFromResult = new  Set<Id>();                                       
        Set<State__c> setOfStateToUpdate = new Set<State__c>();
        List<State__c> listOfStateToUpdate = new List<State__c>();
        List<State__c> statesList =[SELECT Id, Name FROM State__c WHERE Id IN: setOfStateIds];   
        Map<Id,AggregateResult> mapOfAggregateResult = new Map<Id,AggregateResult>();                                                                         
        for(AggregateResult result: groupedResultFromDist){
            IdOfDistsFromResult.add((Id)result.get('State__c'));
            mapOfAggregateResult.put((Id)result.get('State__c'),result);
        }
        for(State__c st : statesList){
            if(mapOfAggregateResult.containsKey(st.Id)){
                AggregateResult result = mapOfAggregateResult.get(st.Id);
                st.Total_Districts_Number__c=(Integer)result.get('totDists');
                setOfStateToUpdate.add(st);
            }
        }
        //This list contains those State Ids that dont have any related district
        //We made this list seperately as Aggregate result could not count 0 for no related districts.
        List<State__c> stList=[SELECT Id FROM State__c WHERE (Id IN: setOfStateIds AND Id NOT IN: IdOfDistsFromResult)];
        for(State__c st: stList){
            st.Total_Districts_Number__c=0;         //No related district
            setOfStateToUpdate.add(st);
        }
        //To update ---> State JSON Data
        listOfStateToUpdate.addAll(setOfStateToUpdate);
        if(listOfStateToUpdate.size()>0){
            update listOfStateToUpdate;
        }
        mapOfAggregateResult.clear();
        //________________________________________________________________________________________________________________
        Set<Id> setOfModifiedStateIds = new Set<Id>();
        List<State__c> statesListToModify=[SELECT Name,Country__c FROM State__c WHERE Id In: setOfStateIds];
        for(State__c state : statesListToModify){
            setOfModifiedStateIds.add(state.Id);
        }
        List<AggregateResult> groupedResultFromState =[SELECT Country__c,SUM(Total_Districts_Number__c) totDis FROM State__c GROUP BY Country__c];
        Set<Id> setOfCountryIds = new Set<Id>();
        for(AggregateResult result: groupedResultFromState){
            setOfCountryIds.add((Id)result.get('Country__c'));
        }
        Set<Id> IdOfStatesFromResult = new  Set<Id>();                                      
        Set<Country__c> setOfCountryToUpdate = new Set<Country__c>();
        List<Country__c> listOfCountryToUpdate = new List<Country__c>();
        List<Country__c> countryList =[SELECT Id, Name FROM Country__c WHERE Id IN: setOfCountryIds];
        for(AggregateResult result: groupedResultFromState){
            IdOfStatesFromResult.add((Id)result.get('Country__c'));
            mapOfAggregateResult.put((Id)result.get('Country__c'),result);
        }
        for(Country__c country : countryList){
            if(mapOfAggregateResult.containsKey(country.Id)){
                AggregateResult result = mapOfAggregateResult.get(country.Id);
                country.Total_Districts__c=(Decimal)result.get('totDis');
                setOfCountryToUpdate.add(country);
            }
        }
        List<Country__c> countriesList=[SELECT Id FROM Country__c WHERE (Id IN: setOfCountryIds AND Id NOT IN: IdOfStatesFromResult)];
        for(Country__c country: countriesList){
            country.Total_Districts__c=0;         //No related district
            setOfCountryToUpdate.add(country);
        }
        listOfCountryToUpdate.addAll(setOfCountryToUpdate);
        if(listOfCountryToUpdate.size()>0){
            update listOfCountryToUpdate;
        }
        //Now we will update ---> State JSON Data field and Country JSON Data field
        if(setOfCountryToUpdate.size()>0){
            DistrictTriggerHelper.populateCountryAndStateJSONData(setOfCountryIds,setOfStateIds);
        }
    }

    /*
    *
    *   Purpose :   Populates the Country JSON data field and State JSON Data field when district record is
    *               inserted, updated, deleted or undeleted.
    *
    */
    public static void populateCountryAndStateJSONData(Set<Id> setOfCountryIds,Set<Id> setOfStateIds){
        Map<String, Object> combinationMap = new Map<String, Object>();
        Map<String, Object> countryMap = new Map<String, Object>();               
        Map<String, Object> stateMap = new Map<String, Object>();
        Map<String, Object> stateMapOfParticularStates = new Map<String, Object>();
        Map<String, Object> distMap = new Map<String, Object>();
        Map<String, Object> clonedDistMap = new Map<String, Object>();
        List<Country__c> countriesList =[SELECT Name,Country_Code__c,Total_States__c,Total_Districts__c,Country_JSON_Data__c FROM Country__c 
                                    WHERE Id IN: setOfCountryIds];
        List<State__c> statesSet = [SELECT Country__c, Name, State_Code__c,Total_Districts_Number__c, State_JSON_Data__c FROM State__c 
                                    WHERE Country__c IN: setOfCountryIds];
        List<District__c> distSet =[SELECT State__c, Name FROM District__c];
        Set<String> setOfDistricts= new Set<String>();
        Map<String,Set<String>> mapOfDistrictsWithState=new Map<String,Set<String>>();
        Set<String> setOfDists= new Set<String>();
        Set<String> setOfStates= new Set<String>();
        Set<State__C> setOfStatesJSONToUpdate = new Set<State__C>();
        List<State__C> listOfStatesJSONToUpdate = new List<State__C>();
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
                    if(setOfStateIds.contains(st.Id)){
                        stateMapOfParticularStates.put('District of '+st.State_Code__c,clonedDistMap);
                        stateMapOfParticularStates.put('Total Districts',st.Total_Districts_Number__c);
                        stateMapOfParticularStates.put('State Code',st.State_Code__c);
                        stateMapOfParticularStates.put('State Name '+st.State_Code__c, setOfStates);
                        st.State_JSON_Data__c=JSON.SerializePretty(stateMapOfParticularStates);
                        setOfStatesJSONToUpdate.add(st);
                    }
                    stateMap.put('State Name '+st.State_Code__c, setOfStates);                     
                    distmap.clear();
                    mapOfDistrictsWithState.remove(st.Name);
                    setOfDists.clear();
                    stateMapOfParticularStates.clear();
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
        if(setOfStatesJSONToUpdate.size()>0){
            listOfStatesJSONToUpdate.addAll(setOfStatesJSONToUpdate);
            update listOfStatesJSONToUpdate;
        }
        if(countriesList.size()>0){
            update countriesList;
        }
    }
}