/*
 * 	Description		:	To understand hierarchichal collections by relating country code-country-state-district
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	28/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 28/06/2022
 * */
public with sharing class Country_MapController {
    Map<String,List<String>> mapOfDistrictsWithListOfIndia = new Map<String,List<String>>();
    Map<String,List<String>> mapOfDistrictsWithListOfEgypt = new Map<String,List<String>>();
    Map<String,List<String>> mapOfDistrictsWithListOfSriLanka = new Map<String,List<String>>();
    Map<String,List<String>> mapOfDistrictsWithListOfGermany = new Map<String,List<String>>();

    Map<String,Map<String,List<String>>> mapOfStatesWithCountryIndia = new Map<String,Map<String,List<String>>>();
    Map<String,Map<String,List<String>>> mapOfStatesWithCountryEgypt = new Map<String,Map<String,List<String>>>();
    Map<String,Map<String,List<String>>> mapOfStatesWithCountrySriLanka = new Map<String,Map<String,List<String>>>();
    Map<String,Map<String,List<String>>> mapOfStatesWithCountryGermany = new Map<String,Map<String,List<String>>>();

    Map<String,Map<String,Map<String,List<String>>>> mapOfCountryWithCountryCode = new Map<String,Map<String,Map<String,List<String>>>>();

    public Country_MapController() {
        //-----Map of States with theit districts-----
        mapOfDistrictsWithListOfIndia.put('Rajasthan',new List<String>{'Ajmer','Jaipur','Udaipur'});
        mapOfDistrictsWithListOfIndia.put('West Bengal',new List<String>{'North 24 parganas','Kolkata','South 24 parganas'});
        mapOfDistrictsWithListOfIndia.put('Delhi',new List<String>{'Darya Ganj','Saket','Shahdara'});
        mapOfDistrictsWithListOfIndia.put('UP',new List<String>{'Bareilly','Fatehpur','Allahabad'});
        mapOfDistrictsWithListOfIndia.put('Karnataka',new List<String>{'Udupi','Bidar','Shivamogga'});
        mapOfDistrictsWithListOfIndia.put('Sikkim',new List<String>{'Gangtok','South Sikkim','Lachen'});

        mapOfDistrictsWithListOfEgypt.put('Cairo',new List<String>{'Heliopolis','Old Cairo','Garden city'});

        mapOfDistrictsWithListOfSriLanka.put('Eastern',new List<String>{'Ampara','Batticaloa','Trincomalee'});
        mapOfDistrictsWithListOfSriLanka.put('Southern',new List<String>{'Galle','Mantara','South city'});
        mapOfDistrictsWithListOfSriLanka.put('Uva',new List<String>{'Badulla','Monaragala'});

        mapOfDistrictsWithListOfGermany.put('Berlin',new List<String>{'Mitte','Dahlem'});
        mapOfDistrictsWithListOfGermany.put('Munich',new List<String>{'Sendling','Moosach','Altstadt'});

        //-----Map of Countries with their States-----
        mapOfStatesWithCountryIndia.put('India',mapOfDistrictsWithListOfIndia);
        mapOfStatesWithCountryEgypt.put('Egypt',mapOfDistrictsWithListOfEgypt);
        mapOfStatesWithCountrySriLanka.put('Sri Lanka',mapOfDistrictsWithListOfSriLanka);
        mapOfStatesWithCountryGermany.put('Germany',mapOfDistrictsWithListOfGermany);

        //-----Map of Country code with their Countries-----
        mapOfCountryWithCountryCode.put('91', mapOfStatesWithCountryIndia);
        mapOfCountryWithCountryCode.put('20', mapOfStatesWithCountryEgypt);
        mapOfCountryWithCountryCode.put('94', mapOfStatesWithCountrySriLanka);
        mapOfCountryWithCountryCode.put('49', mapOfStatesWithCountryGermany);

        //Displaying the initialized map
        System.debug('Map of Country codes with Country name with States and Districts:- ');
        System.debug(mapOfCountryWithCountryCode);   
        
        //Calling the two methods
        getPlacesWithS();
        getMaxLengthDistrict();
    }
    
    /*
    *
    *   Purpose :   Finds a combination of related Country, State, City which begins with "S"
    *
    */
    public void getPlacesWithS(){
        System.debug('Combination of related Country, State, City which begins with "S" :- ');
        Boolean found=false;
        for(Map<String,Map<String,List<String>>> country_state_district : mapOfCountryWithCountryCode.values()){
            for(String country : country_state_district.keySet()){
                if(country.startsWith('S')){
                    for(Map<String,List<String>> state_district : country_state_district.values()){
                        for(String state : state_district.keySet()){
                            if(state.startsWith('S')){
                                for(List<String> districtList: state_district.values()){
                                    for(String district: districtList){
                                        if(district.startsWith('S')){
                                            System.debug('Country '+country+' has State '+state+' which has the District '+district);
                                            found = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        if(found== false){System.debug('No such combination was found');}
    }

    /*
    *
    *   Purpose :   Finds those districts with length more than 10
    *
    */
    public void getMaxLengthDistrict(){
        Integer district_length=0,i=0;
        List<String> large_districts = new List<String>();
        for(Map<String,Map<String,List<String>>> country_state_district : mapOfCountryWithCountryCode.values()){            
            for(Map<String,List<String>> state_district : country_state_district.values()){                    
                for(List<String> districtList: state_district.values()){
                    for(String district: districtList){
                        district_length=district.length();
                        if(district_length>10){
                        large_districts.add(district);
                        }    
                    }
                }                    
            }                
        }
        System.debug('Districts with number of letters more than 10 :- '+large_districts);
    }
}