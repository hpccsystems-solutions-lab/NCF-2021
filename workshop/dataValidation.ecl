IMPORT $.getFlights;


//Record definition that contains validation indicators
//Transfrom result layout
ValidDataLayout := RECORD
		BOOLEAN				InvalidFlight;
		BOOLEAN				InvalidDates;
		BOOLEAN				Blanklocations;
		INTEGER2 			FlightNumber;
		STRING8				EffectiveDate; 			
		STRING8 			DiscontinueDate;		
		STRING3 			DepartStationCode;
		STRING2 			DepartCountryCode;
		STRING3 			ArriveStationCode;
		STRING2 			ArriveCountryCode; 
		//TODO: Add more indicators

END;


//Rewrite the data into the new layout, adding validation check results
//along the way
validatedData := PROJECT(getFlights.gsecData, 
						 TRANSFORM(ValidDataLayout,
						 			SELF.InvalidFlight := LEFT.carrier = '' OR LEFT.FlightNumber = 0,
									SELF.InvalidDates  := LEFT.EffectiveDate = '' OR LEFT.DiscontinueDate = '',
									SELF.Blanklocations := LEFT.DepartStationCode = '' OR LEFT.ArriveStationCode = '',
                  //TODO: Evaluate additional indicators
                  //TODO: Don't forget to add indicators to next assignment

                  SELF := LEFT
						 			));
                  
OUTPUT(validatedData(InvalidFlight OR 
       InvalidDates OR 
       Blanklocations), 
       NAMED('InvalidatedData'));
       
OUTPUT(validatedData( NOT InvalidFlight OR 
       NOT InvalidDates OR 
       NOT Blanklocations), 
              NAMED('ValidatedData'));
