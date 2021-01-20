// read raw data
training_Layout1:= RECORD
    UNSIGNED4       date;
    DECIMAL6_3      temperature;
    UDECIMAL4_2     windspeed;
    UDECIMAL4_2     visibility;
    UDECIMAL4_2     cloudcover;
END;

raw := DATASET('~NCF2021::ML::NY_taxi_trips_raw.csv', training_Layout1, FLAT);

OUTPUT(raw[1..100]);
