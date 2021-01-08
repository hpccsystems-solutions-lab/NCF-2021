IMPORT $.getFlights;

//1- Sort by effective date and flight number, save result in sortedData
sortedData := SORT(getFlights.gsecData, EffectiveDate, FlightNumber);

//2- Filter down to only Delta(DL) flights operating in November 2019
//Display result as filteredData
filteredData := sortedData(Carrier = 'DL' AND 
                        EffectiveDate BETWEEN '20191101' AND '20191130');

OUTPUT(filteredData, NAMED('filteredData'));

//3- Display Flights that thier DepartStationCode are in LHR or ORD 
//and ArriveStationCode is in JFK, ATL, or ORD.
//Sort the result Carrier and FlightNumber 
getStations := getFlights.gsecData(DepartStationCode IN ['LHR', 'ORD'] AND
                                ArriveStationCode IN ['JFK', 'ATL', 'ORD']);
sortRes := SORT(getStations, Carrier, FlightNumber);
OUTPUT(sortRes, NAMED('sortedStations'));