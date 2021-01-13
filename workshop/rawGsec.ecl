#WORKUNIT('name', 'GSEC Raw');

//------------------------------------------------------------------------------

// Layout of the raw data; everything is a STRING
rawGsecREC := RECORD
		STRING3				Carrier;
		INTEGER2 			FlightNumber;
		STRING1				CodeShareFlag;
		STRING3				CodeShareCarrier; 	
		STRING1				ServiceType;				
		STRING8				EffectiveDate; 			
		STRING8 			DiscontinueDate;		
		UNSIGNED1 			IsOpMon;
		UNSIGNED1 			IsOpTue;
		UNSIGNED1 			IsOpWed;
		UNSIGNED1 			IsOpThu;
		UNSIGNED1 			IsOpFri;
		UNSIGNED1 			IsOpSat;
		UNSIGNED1 			IsOpSun;
		STRING3 			DepartStationCode;
		STRING2 			DepartCountryCode;
		STRING2 			DepartRegionCode;			
		STRING2				DepartStateProvCode; 	
		STRING3 			DepartCityCode;				
		STRING10 			DepartTimePassenger; 	 
		STRING10 			DepartTimeAircraft;  	 
		STRING5 			DepartUTCVariance;		
		STRING2 			DepartTerminal;				
		STRING3 			ArriveStationCode;
		STRING2 			ArriveCountryCode; 		
		STRING2 			ArriveRegionCode;			
		STRING2				ArriveStateProvCode; 	 
		STRING3 			ArriveCityCode;				
		STRING10 			ArriveTimePassenger; 	 
		STRING10 			ArriveTimeAircraft;  	 
		STRING5 			ArriveUTCVariance;		
		STRING2 			ArriveTerminal;							
		STRING3 			EquipmentSubCode; 
		STRING3 			EquipmentGroupCode;		
		VARSTRING4 		CabinCategoryClasses;
		VARSTRING40 	BookingClasses;
		STRING1 			TrafficRestriction;			
		INTEGER1 			ArriveDayIndicator;
		INTEGER1 			NumberOfIntermediateStops;
		VARSTRING50 	IntermediateStopStationCodes;
		VARSTRING20 	IntermediateStopRestrictions;
		BOOLEAN 			IsEquipmentChange;
		VARSTRING60 	EquipmentCodesAcrossSector; 
		VARSTRING80 	MealCodes;
		INTEGER2 			FlightDurationLessLayover; // Refers to Actual Air time of flight. This does not include layover.
		INTEGER2 			FlightDistance;
		INTEGER2 			FlightDistanceThroughIndividualLegs; 
		INTEGER2 			LayoverTime;
		INTEGER2 			IVI;
		INTEGER2 			FirstLegNumber;
		VARSTRING50 	InFlightServiceCodes;
		BOOLEAN 			IsCodeShare;
		BOOLEAN 			IsWetLease;
		VARSTRING155	CodeShareInfo;
		VARSTRING80 	AircraftOwnerInfo;
		STRING1 			OperationalSuffix;				
		
		INTEGER 	FirstClassSeats; 			// AVG_F
		INTEGER 	BusinessClassSeats; 	// AVG_CJ
		INTEGER 	PremiumEconomySeats; 	// AVG_PY
		INTEGER 	EconomyClassSeats; 	 	// AVG_YW
		INTEGER		TotalSeats;						// AVG_SEAT
		INTEGER 	AircraftTonnage;			// AVG_TONNAGE
		
		// Fields added for additional requirements
		STRING20  	ACV;
		VARSTRING50 EquipmentChangeStops;
		STRING2			MCTIndicator;
		
		// Fields added for additional requirements
		STRING    IntStopArrivalTime;
		STRING    IntStopDepartTime;
		STRING    IntStopNextDay;
		STRING		PhysicalLegKey;
		STRING    ReleaseSellDate;
		STRING 		SecureFlightInd;
		STRING		AircraftOwner;
		STRING		CockPitCrewEmp;
		STRING    CabinCrewEmp;
		STRING 		OnwdFlt; //Onward Flight
		STRING		AutoCheckIn;
		STRING		DateVariation;
		
		STRING		DEI011;
		STRING    DEI201;
		STRING		DEI299;
		STRING		DEI501;
	  STRING  	DEI502;
		STRING    DEI503;
		STRING		DEI505;
		
		STRING	PhysicalSectIDKey;
		UNSIGNED	SectorizedId;
		
	END;






//2019::flights::schedules::all::fields::csv
//raw::flight::schedule::2019


RawGsecDS := DATASET('~2019::flights::schedules::all::fields::csv', 
                    rawGSECRec,  
                    CSV(HEADING(1))); 


GSECRec := RECORD
    STRING3             Carrier;                                // two or three letter code assigned by IATA or ICAO for the Carrier
    INTEGER2            FlightNumber;                           // flight number
    STRING1             CodeShareFlag;                          // service type indicator is used to classify carriers according to the type of air service they provide
    STRING3             CodeShareCarrier;                       // alternate flight designator or ticket selling airline
    STRING1             ServiceType;                            // classify carriers according to the type of air service they provide
    STRING8             EffectiveDate;                          // effective date represents the date that the carrier has scheduled this flight service to begin; YYYYMMDD
    STRING8             DiscontinueDate;                        // discontinued date represents the last date that the carrier has scheduled this flight service to operate; YYYYMMDD
    UNSIGNED1           IsOpMon;                                // indicates whether the flight has service on Monday
    UNSIGNED1           IsOpTue;                                // indicates whether the flight has service on Tuesday
    UNSIGNED1           IsOpWed;                                // indicates whether the flight has service on Wednesday
    UNSIGNED1           IsOpThu;                                // indicates whether the flight has service on Thursday
    UNSIGNED1           IsOpFri;                                // indicates whether the flight has service on Friday
    UNSIGNED1           IsOpSat;                                // indicates whether the flight has service on Saturday
    UNSIGNED1           IsOpSun;                                // indicates whether the flight has service on Sunday
    STRING3             DepartStationCode;                      // standard IATA Airport code for the point of trip origin
    STRING2             DepartCountryCode;                      // standard IATA Country code for the point of trip origin
    STRING2             DepartStateProvCode;                    // Innovata State Code
    STRING3             DepartCityCode;                         // departure city code contains the city code for the point of trip origin
    STRING10            DepartTimePassenger;                    // published flight departure time; HHMMSS
    STRING10            DepartTimeAircraft;                     // agreed SLOT departure time; HHMMSS
    STRING5             DepartUTCVariance;                      // UTC Variant for the departure airport; [+-]HHMM
    STRING2             DepartTerminal;                         // departure terminal
    STRING3             ArriveStationCode;                      // standard IATA Airport code for the point of arrival
    STRING2             ArriveCountryCode;                      // standard IATA Country code for the point of arrival
    STRING2             ArriveStateProvCode;                    // Innovata State Code
    STRING3             ArriveCityCode;                         // arrival city code contains the city code for the point of trip origin
    STRING10            ArriveTimePassenger;                    // published flight arrival time; HHMMSS
    STRING10            ArriveTimeAircraft;                     // agreed SLOT arrival time; HHMMSS
    STRING5             ArriveUTCVariance;                      // UTC Variant for the arrival airport; [+-]HHMM
    STRING2             ArriveTerminal;                         // arrival terminal
    STRING3             EquipmentSubCode;                       // sub aircraft type on the first leg of the flight
    STRING3             EquipmentGroupCode;                     // group aircraft type on the first leg of the flight
    VARSTRING4          CabinCategoryClasses;                   // most commonly used service classes
    VARSTRING40         BookingClasses;                         // full list of Service Class descriptions
    INTEGER1            ArriveDayIndicator;                     // signifies which day the flight will arrive with respect to the origin depart day; <blank> = same day, -1 = day before, 1 = day after, 2 = two days after
    INTEGER1            NumberOfIntermediateStops;              // set to zero (i.e. nonstop) if the flight does not land between the point of origin and final destination
    VARSTRING50         IntermediateStopStationCodes;           // IATA airport codes where stops occur, separated by “!”
    BOOLEAN             IsEquipmentChange;                      // signifies whether there has been an aircraft change at a stopover point for the flight leg
    VARSTRING60         EquipmentCodesAcrossSector;             // sub-aircraft type on each leg of the flight
    VARSTRING80         MealCodes;                              // contains up to two meal codes per class of service
    INTEGER2            FlightDurationLessLayover;              // fefers to Actual Air time of flight; does not include layover time
    INTEGER2            FlightDistance;                         // shortest distance (in miles) between the origin and destination points
    INTEGER2            FlightDistanceThroughIndividualLegs;
    INTEGER2            LayoverTime;                            // minutes
    INTEGER2            IVI;
    INTEGER2            FirstLegNumber;
    VARSTRING50         InFlightServiceCodes;
    BOOLEAN             IsCodeShare;                            // true if flight is operated by another carrier
    BOOLEAN             IsWetLease;                             // true if wet lease (owned by one carrier and operated by another)
    VARSTRING155        CodeShareInfo;                          // information regarding operating and marketing carriers
    INTEGER             FirstClassSeats;
    INTEGER             BusinessClassSeats;
    INTEGER             PremiumEconomySeats;
    INTEGER             EconomyClassSeats;
    INTEGER             TotalSeats;
    UNSIGNED            SectorizedId;                           // unique record ID
END;

res := PROJECT(RawGsecDS, TRANSFORM(GSECRec,
                            SELF := LEFT));

OUTPUT(res,, '~flight::schedule_2019', THOR);
//2019::international::flights::schedules