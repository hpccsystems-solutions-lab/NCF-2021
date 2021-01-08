IMPORT $.getFlights;

//1- Get the min FlightNumber, save and display result as minFlightNumber
minFlightNumber := MIN(getFlights.gsecData, FlightNumber);
OUTPUT(minFlightNumber, NAMED('minFlightNumber'));

//2- filter your dataset for minFlightNumber and display results as getFlightNumbers
getFlightNumbers := getFlights.gsecData( FlightNumber = FlightNumber);
OUTPUT(getFlightNumbers, NAMED('getFlightNumbers'));

//3- How may rows are in getFlightNumbers?
OUTPUT(COUNT(getFlightNumbers), NAMED('Count_getFlightNumbers'));
