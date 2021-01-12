IMPORT $.getAirlines;
IMPORT $.getFlights;
IMPORT $.getServiceTypes;

//Let's review the Airline ds
OUTPUT(CHOOSEN(getAirlines.AirlinesDS, 100), NAMED('Airlines_DS'));


//Record layout for result
AppendRec := RECORD
  STRING3   Carrier;                               
  STRING    Airline;
  INTEGER2  FlightNumber; 
  STRING    DepartStationCode;
  STRING    ArriveStationCode;
  STRING1   ServiceType;
  //TODO: Add AirlineCountry from AirlinesDS
END;

AppendAirlines := JOIN(getFlights.gsecData,      //Left dataset
                  getAirlines.AirLinesDS,   //Right dataset
                  LEFT.Carrier = RIGHT.Iata, //Matching condition
                  TRANSFORM(AppendRec,
                  SELF.Airline := RIGHT.Airline_Name,
                  //TODO: Add AirlineCountry
                  SELF := LEFT));

OUTPUT(SORT(AppendAirlines, FlightNumber ,DepartStationCode), NAMED('AppendAirlines'));

//Let's review this
COUNT(AppendAirlines);
COUNT(getFlights.gsecData);

//Adding Airline names 
AppendServiceRec := RECORD
  AppendRec;
  //TODO: Add service description from serviceTypes
  STRING      ServiceDesc;
END;

//Adding descriptions of ServieTypes
AddService := JOIN(AppendAirlines,
                  getServiceTypes.serviceTypesDS,
                  LEFT.ServiceType = RIGHT.code,
                  TRANSFORM(AppendServiceRec,
                  SELF.ServiceDesc := RIGHT.Desc,
                  SELF := LEFT
                  //TODO: Service type and it's decsrption
                  //TODO: Remove SELF := []
                 //SELF := []
                  ));

OUTPUT(SORT(AddService, FlightNumber ,DepartStationCode), NAMED('AddService'));
