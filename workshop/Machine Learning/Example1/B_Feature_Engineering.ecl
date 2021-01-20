// read raw data
training_Layout1:= RECORD
    UNSIGNED4       date;
    DECIMAL6_3      temperature;
    UDECIMAL4_2     windspeed;
    UDECIMAL4_2     visibility;
    UDECIMAL4_2     cloudcover;
END;

raw := DATASET('~NCF2021::ML::NY_taxi_trips_raw.csv', training_Layout1, FLAT);

// feature engineer
training_Layout2 := RECORD
    UNSIGNED4       date;
    DECIMAL6_3      temperature;
    UDECIMAL4_2     windspeed;
    UDECIMAL4_2     visibility;
    UDECIMAL4_2     cloudcover;
    INTEGER         trips; 
END;

engineered_ds := ROLLUP(GROUP(SORT(raw, date), date),
                    GROUP,
                    TRANSFORM(training_Layout2,
                    SELF.temperature := AVE(ROWS(LEFT), temperature),
                    SELF.windspeed  := AVE(ROWS(LEFT), windspeed),
                    SELF.visibility := AVE(ROWS(LEFT), visibility),
                    SELF.cloudcover := AVE(ROWS(LEFT), cloudcover),
                    SELF.trips := COUNT(ROWS(LEFT)),
                    SELF := LEFT
                    ));

OUTPUT(engineered_ds[1..100]);
OUTPUT(engineered_ds, , '~NCF2021::ML::engineered_ds', OVERWRITE);