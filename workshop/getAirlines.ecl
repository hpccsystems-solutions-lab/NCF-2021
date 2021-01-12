EXPORT getAirlines := MODULE

EXPORT  airlinesRec := RECORD   
    INTEGER Airline_ID;
    STRING	Name;
    STRING 	IATA;
    STRING	ICAO;
    STRING	Airline_Name;
    STRING	Country;
    STRING  Active;

END;

EXPORT AirlinesDS := DATASET('~airlines::thor', airlinesRec, THOR);

END;