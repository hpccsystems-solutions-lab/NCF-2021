IMPORT $.getAirlines;
IMPORT $.getFlights;
IMPORT $.getServiceTypes;

//Let's review the Airline ds
OUTPUT(CHOOSEN(getAirlines.AirlinesDS, 100), NAMED('Airlines_DS'));

//***********************************************************
//Part One

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

//TODO: Sort the result by FlightNumber ,DepartStationCode
//TODO: Save the result under: AppendAirlines
SortedAirlines := SORT(AppendAirlines, FlightNumber ,DepartStationCode);
OUTPUT(CHOOSEN(SortedAirlines, 100), NAMED('SortedAirlines'));


//TODO: Count your total gsecData and your sortedAirlines
//TODO: What do you think? Let's review
COUNT(AppendAirlines);
COUNT(getFlights.gsecData);

//***********************************************************
//Part Two

//Adding Airline names 
AppendServiceRec := RECORD
  AppendRec;
  //TODO: Add service description from serviceTypes dataset
  //TODO: Name it ServiceDesc
  STRING      ServiceDesc;
END;

//Adding descriptions of ServieTypes
AddService := JOIN(AppendAirlines,
                  getServiceTypes.serviceTypesDS,
                  LEFT.ServiceType = RIGHT.code,
                  TRANSFORM(AppendServiceRec,
                  //TODO: Add ServiceDesc
                  SELF.ServiceDesc := RIGHT.Desc,
                  //SELF := LEFT
                  //TODO: Does everything look ok?
                  SELF := [];
                  ));

//TODO: Sort by FlightNumber ,DepartStationCode
//TODO: Save result under FinalResult
FinalResult := SORT(AddService, FlightNumber ,DepartStationCode);
OUTPUT(CHOOSEN(FinalResult, 100), NAMED('FinalResult'));
