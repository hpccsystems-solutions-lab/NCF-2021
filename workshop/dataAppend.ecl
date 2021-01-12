IMPORT getAirlines;
IMPORT getFlights;

//Let's review the Airline ds
OUTPUT(CHOOSEN(getAirlines.AirlinesDS, 100), NAMED('Airlines_DS'));


//Record layout for result
AppendRec := RECORD
  STRING3   Carrier;                               
  STRING    Airline;
  INTEGER2  FlightNumber; 
  STRING    DepartStationCode;
  STRING    ArriveStationCode;
  //TODO: Add AirlineCountry from AirlinesDS
END;

AppendRes := JOIN(getFlights.gsecData,      //Left dataset
                  getAirlines.AirLinesDS,   //Right dataset
                  LEFT.Carrier = RIGHT.Iata, //Matching condition
                  TRANSFORM(AppendRec,
                  SELF.Airline := RIGHT.Name,
                  //TODO: Add AirlineCountry
                  SELF := LEFT));

OUTPUT(SORT(AppendRes, FlightNumber ,DepartStationCode), NAMED('AppendRes'));

//Let's review this
COUNT(AppendRes);
COUNT(getFlights.gsecData);