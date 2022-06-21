/*
 * 	Description		:	Different collection types and their methods
 * 
 *  Created By		:	Soumi Chakraborty
 * 
 * 	Created Date	:	16/06/2022
 * 
 * 	Revision Logs	: 	V_1.0 - Created By - Soumi Chakraborty - 16/06/2022
 * 					:	V_1.1 - Modifided By - Soumi Charaborty - 19/06/2022 (Code Optimized in section #4)
 * 
 *  Assignments 	:	List<String>                                 ->Line no. 21
 *						Set<String>                                  ->Line no. 60
 *						Map<String,String>                           ->Line no. 102  
 *					    Map<String,List<String>>					 ->Line no. 127, 139
 *						Map<String,Map<String,String>>	             ->Line no. 166
 *						Map<String,Map<String,List<String>>>         ->Line no. 181
 *						Map<String,Map<String,Map<String,String>>>	 ->Line no. 190
 *  
 * */
public class CollectionsLearning {
    public static void listFunctions(){
        List<String> names = new List<String>();               //#1.
        names.add('Soumi');
        names.add('Anima');
        names.add('Rajkumar');
        names.add(1,'Arunava');
        names.add('Sharmistha');
        names.add(4,'Soumi');
        System.debug('Names list 1- '+names);
        System.debug('Size of the names list is before modification : '+names.size()+'\n');
        
        System.debug('Name at index 3 is - '+names.get(3)+'\n');
        names.remove(3);
     	
        System.debug('Names list 1 after modification- '+names);
        System.debug('Size of the names list is after modification : '+names.size());
        
        List<String> names_2 = new List<String>{'Shalu madam','Komal','Tapendra'};
        System.debug('\n New names list 2- '+names_2);
        
        System.debug('Is first names list same as second names list - '+names.equals(names_2));
        
        names.addAll(names_2);
        System.debug('After appending new list  to previous list - '+names);
        
        System.debug('Index of "Sharmistha" is : '+names.indexOf('Sharmistha'));
        names.set(4,'John');
        System.debug('Replacing "Sharmistha" with "John" - '+names);
        System.debug('Does names list contain the name "Partha" - '+names.contains('Partha'));
        names.sort();
        System.debug('Sorted names list - '+names);
        System.debug('Is names list empty ? -'+names.isEmpty());
        names.clear();
        System.debug('Cleared names list, now is the names list empty ? -'+names.isEmpty());
        
        Integer[] numbers = new List<Integer>{5,7,9,3,7,4};
        System.debug('Numbers list - '+numbers);
        System.debug('Numbers list changed to string type : '+numbers.toString());
    }
    public static void setFunctions(){
        Set<String> colors = new Set<String>();                     //#2.
        colors.add('Purple');
        colors.add('Blue');
        colors.add('Green');
        colors.add('Red');
        colors.add('Blue');
        colors.add('Blue');
        colors.add('Pink');
        System.debug('Set of Colors - '+colors);
        System.debug('Size of colors set : '+colors.size());
        
        List<String> listColors = new List<String>{'Blue','Violet','Blue','Cyan','Yellow'};
        colors.addAll(listColors);
        System.debug('New set of colors after adding from a list - '+colors);
        System.debug('Does set1 contain the list of colors? - '+colors.containsAll(listColors));
        
        Set<String> colors_2 = new Set<String>{'Red','Orange','Pink','White'};
        System.debug('Does set1 contains set2 ? - '+colors.containsAll(Colors_2));
        
        System.debug('Is "Black" color present in the set1? - '+colors.contains('Black'));
        
        Set<String> colors_3 = new Set<String>(colors);
        System.debug('Is the copied set equal to the set 1? -'+colors.equals(colors_3));
        
        List<String> badColors= new List<String>{'Orange','Yellow','Cyan'};
        colors.removeAll(badColors);
        
        System.debug('Modified set after removing the list of bad colors'+colors);
        colors.remove('Red');
        System.debug('Removing "Red" again from the set - '+colors);
        
        Set<String> favColors = new Set<String>{'Pink','Blue','Purple'};
        colors.retainAll(favColors);
        System.debug('Color list showing only favorite colors - '+colors);
        
        System.debug('Is the colors set empty? - '+colors.isEmpty());
        colors.clear();
        System.debug('Colors set after clearing elements - '+colors);
    }
    public static void mapFunctions(){
        
        //#3.
        Map<String,String> studentsId = new Map<String,String>{'Soumi'=>'BCA012','Amisha'=>'BCA006','Sharmistha'=>'BCA016'};
        
        studentsId.put('Mrinal','BCA015');
        studentsId.put('Krishna','BCA026');
        System.debug('Map of Students name and their id - '+studentsId);
        System.debug('Size of the map : '+studentsId.size());
        
        System.debug('Id i.e. value of key "Soumi" is- '+studentsId.get('Soumi'));
        
        studentsId.remove('Krishna');
        System.debug('Removing the key "Krishna" and the map is now- '+studentsId);
        
        System.debug('Is the key "Anima" present in the map? - '+studentsId.containsKey('Anima'));
        
        System.debug('All keys : '+studentsId.keySet());
        System.debug('All values : '+studentsId.values());
        
        Map<String,String> newStudentsId = new Map<String,String>{'Arunava'=>'BCA011', 'Rajkumar'=>'BCA005'};
        System.debug('New map - '+newStudentsId);
        studentsId.putAll(newStudentsId);
        System.debug('Map after adding new Map - '+studentsId);
        
        //---------------------------------------------------------------------------------------------------------------------
        
        Map<String,List<String>> citiesOfEuropeanCountries = new Map<String,List<String>>();    //#4.
        //List<String> citiesOfGermany = new List<String>{'Berlin','Munich'};
        //citiesOfEuropeanCountries.put('Germany',citiesOfGermany);
        citiesOfEuropeanCountries.put('Germany',new List<String>{'Berlin','Munich'});
        
        //List<String> citiesOfEngland = new List<String>{'Paris','France'};
        //citiesOfEuropeanCountries.put('England',citiesOfEngland);        
        //System.debug('Map of European Country-City: '+citiesOfEuropeanCountries);        
        citiesOfEuropeanCountries.put('England',new List<String>{'Paris','France'});
        
        System.debug('Map of European Country-City: '+citiesOfEuropeanCountries);
        
        Map<String,List<String>> citiesOfAsianCountries = new Map<String,List<String>>();     //#4.
        //List<String> citiesOfIndia = new List<String>{'Kolkata','Delhi','Mumbai'};
            
        //citiesOfAsianCountries.put('India',citiesOfIndia);
        citiesOfAsianCountries.put('India',new List<String>{'Kolkata','Delhi','Mumbai'});
        //List<String> citiesOfNepal = new List<String>{'Kathmandu','Tansen'};
        //citiesOfAsianCountries.put('Nepal',citiesOfNepal);
        citiesOfAsianCountries.put('Nepal',new List<String>{'Kathmandu','Tansen'});
        //List<String> citiesOfJapan = new List<String>{'Tokyo','Kyoto'};
        //citiesOfAsianCountries.put('Japan',citiesOfJapan);
        citiesOfAsianCountries.put('Japan',new List<String>{'Tokyo','Kyoto'});
        
        System.debug('Map of Asian Country-City: '+citiesOfAsianCountries);
        
        System.debug('List of countries of Asia: '+citiesOfAsianCountries.keySet());
        System.debug('List of cities of Asia : '+citiesOfAsianCountries.values()+'\n');
        
        for(String country : citiesOfAsianCountries.keySet()){
            System.debug('Country '+country+' has the cities ');
            for(String city :citiesOfAsianCountries.get(country)){
                System.debug(city+' ');
            }
            System.debug('\n');
        }
        
        //---------------------------------------------------------------------------------------------------------------------
        
        Map<String,Map<String,String>> qualNameAdd =new Map<String,Map<String,String>>();          //#5.
        Map<String,String> stuAdd = new Map<String,String>{'Soumi'=>'Barrackpore','Arunava'=>'Sodepur','Sharmistha'=>'Dunlop'};
        Map<String,String> empAdd = new Map<String,String>{'Mrinal'=>'Barasat','Gobindo'=>'Bakura','Soumi'=>'Barrackpore'};
        qualNameAdd.put('Student',stuAdd);
        qualNameAdd.put('Employee',empAdd);
        System.debug(qualNameAdd);
        
        Map<String,Map<String,String>> petHouse =new Map<String,Map<String,String>>();        
        Map<String,String> pets = new Map<String,String>{'Dog'=>'Doghouse', 'Fish'=>'Aquarium','Bird'=>'Cage' };
        petHouse.put('Pets',pets);
        
        System.debug('Where does a dog live? - '+pets.get('Dog'));
        
        //---------------------------------------------------------------------------------------------------------------------
        
        Map<String,Map<String,List<String>>> continents = new Map<String,Map<String,List<String>>>();   //#6.
        continents.put('Asia',citiesOfAsianCountries);
        continents.put('Europe',citiesOfEuropeanCountries);
        System.debug(continents);
        
        System.debug('The countries of Asia and Europe are- '+citiesOfAsianCountries.keySet()+','+citiesOfEuropeanCountries.keySet());
        
        //---------------------------------------------------------------------------------------------------------------------
        
        Map<String,Map<String,Map<String,String>>> livingBeing = new Map<String,Map<String,Map<String,String>>>();  //#7.
        livingBeing.put('Humans',qualNameAdd);
        livingBeing.put('Animals',petHouse);
        System.debug(livingBeing);
        
        System.debug('Name two living beings - '+livingBeing.keySet());
    }
}