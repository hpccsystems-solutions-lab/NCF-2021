IMPORT ML_Core;

// Transform to Machine Learning Model required data format

// Read engineered data
training_Layout2 := RECORD
    UNSIGNED4       date;
    DECIMAL6_3      temperature;
    UDECIMAL4_2     windspeed;
    UDECIMAL4_2     visibility;
    UDECIMAL4_2     cloudcover;
    INTEGER         trips; 
END;

engineered_ds := DATASET('~NCF2021::ML::engineered_ds',training_Layout2, FLAT );

// Only keep useful features
training_Layout3:= RECORD
    UNSIGNED4       id;
    DECIMAL6_3      temperature;
    UDECIMAL4_2     windspeed;
    UDECIMAL4_2     visibility;
    UDECIMAL4_2     cloudcover;
    INTEGER         trips;
END;
transformed_ds := PROJECT(engineered_ds, TRANSFORM(training_layout3, SELF.id := COUNTER, SELF := LEFT));

OUTPUT(transformed_ds[1..100]);
OUTPUT(transformed_ds, , '~NCF2021::ML::transformed_ds', OVERWRITE);


// Train, test split
trainset := transformed_ds[1..400];
testset  := PROJECT(transformed_ds[401..500], TRANSFORM(training_Layout3, SELF.id := COUNTER, SELF := LEFT));
OUTPUT(trainset[1..100]);
OUTPUT(testset[1..100]);

//Transform to NumericField format
ML_Core.ToField(trainset, NFtrain);
ML_Core.ToField(testset, NFtest);
OUTPUT(NFtrain[1..100]);
OUTPUT(NFtest[1..100]);
OUTPUT(NFtrain, , '~NCF2021::ML::NFTrain', OVERWRITE);
OUTPUT(NFtest, , '~NCF2021::ML::NFTest', OVERWRITE);
