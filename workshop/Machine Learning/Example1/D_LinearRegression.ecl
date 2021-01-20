IMPORT ML_Core;
IMPORT ML_Core.Types AS Types;
IMPORT ML_Core.Analysis AS Analysis;
IMPORT LinearRegression AS LROLS;

// Read training data
NFTrain  := DATASET('~NCF2021::ML::NFTrain', Types.NumericField, FLAT);
// Independent and dependent split
trainInd := NFtrain(number < 5 );
trainDep := PROJECT(NFtrain(number = 5 ), TRANSFORM(Types.NumericField, SELF.number := 1, SELF := LEFT));

// Train Linear Regression model
m := LROLS.OLS(trainInd, trainDep);

// Read test data
NFTest   := DATASET('~NCF2021::ML::NFTest',  Types.NumericField, FLAT);
// Independent and dependent split
testInd := NFtest(number < 5 );
testDep := PROJECT(NFtest(number = 5 ), TRANSFORM(Types.NumericField, SELF.number := 1, SELF := LEFT));

// Predict with test data
result := m.Predict(testIND);
OUTPUT(result[1..100]);

// Evaluate model
evaluation :=  Analysis.Regression.Accuracy(result, TestDep);
OUTPUT(evaluation);

