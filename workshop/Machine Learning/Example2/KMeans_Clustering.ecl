IMPORT ML_Core;
IMPORT ML_Core.Types;
IMPORT KMeans ;


//Data Preperation

//Iris Dataset
Layout := RECORD
    Types.t_FieldReal sepal_length;
    Types.t_FieldReal sepal_width;
    Types.t_FieldReal petal_length;
    Types.t_FieldReal petal_width;
    Types.t_FieldReal class;
 END;

ds := DATASET([
    {5.1,3.5,1.4,0.2,0},
    {4.9,3.0,1.4,0.2,0},
    {4.7,3.2,1.3,0.2,0},
    {4.6,3.1,1.5,0.2,0},
    {5.0,3.6,1.4,0.2,0},
    {5.4,3.9,1.7,0.4,0},
    {4.6,3.4,1.4,0.3,0},
    {5.0,3.4,1.5,0.2,0},
    {4.4,2.9,1.4,0.2,0},
    {4.9,3.1,1.5,0.1,0},
    {5.4,3.7,1.5,0.2,0},
    {4.8,3.4,1.6,0.2,0},
    {4.8,3.0,1.4,0.1,0},
    {4.3,3.0,1.1,0.1,0},
    {5.8,4.0,1.2,0.2,0},
    {5.7,4.4,1.5,0.4,0},
    {5.4,3.9,1.3,0.4,0},
    {5.1,3.5,1.4,0.3,0},
    {5.7,3.8,1.7,0.3,0},
    {5.1,3.8,1.5,0.3,0},
    {5.4,3.4,1.7,0.2,0},
    {5.1,3.7,1.5,0.4,0},
    {4.6,3.6,1.0,0.2,0},
    {5.1,3.3,1.7,0.5,0},
    {4.8,3.4,1.9,0.2,0},
    {5.0,3.0,1.6,0.2,0},
    {5.0,3.4,1.6,0.4,0},
    {5.2,3.5,1.5,0.2,0},
    {5.2,3.4,1.4,0.2,0},
    {4.7,3.2,1.6,0.2,0},
    {4.8,3.1,1.6,0.2,0},
    {5.4,3.4,1.5,0.4,0},
    {5.2,4.1,1.5,0.1,0},
    {5.5,4.2,1.4,0.2,0},
    {4.9,3.1,1.5,0.1,0},
    {5.0,3.2,1.2,0.2,0},
    {5.5,3.5,1.3,0.2,0},
    {4.9,3.1,1.5,0.1,0},
    {4.4,3.0,1.3,0.2,0},
    {5.1,3.4,1.5,0.2,0},
    {5.0,3.5,1.3,0.3,0},
    {4.5,2.3,1.3,0.3,0},
    {4.4,3.2,1.3,0.2,0},
    {5.0,3.5,1.6,0.6,0},
    {5.1,3.8,1.9,0.4,0},
    {4.8,3.0,1.4,0.3,0},
    {5.1,3.8,1.6,0.2,0},
    {4.6,3.2,1.4,0.2,0},
    {5.3,3.7,1.5,0.2,0},
    {5.0,3.3,1.4,0.2,0},
    {7.0,3.2,4.7,1.4,1},
    {6.4,3.2,4.5,1.5,1},
    {6.9,3.1,4.9,1.5,1},
    {5.5,2.3,4.0,1.3,1},
    {6.5,2.8,4.6,1.5,1},
    {5.7,2.8,4.5,1.3,1},
    {6.3,3.3,4.7,1.6,1},
    {4.9,2.4,3.3,1.0,1},
    {6.6,2.9,4.6,1.3,1},
    {5.2,2.7,3.9,1.4,1},
    {5.0,2.0,3.5,1.0,1},
    {5.9,3.0,4.2,1.5,1},
    {6.0,2.2,4.0,1.0,1},
    {6.1,2.9,4.7,1.4,1},
    {5.6,2.9,3.6,1.3,1},
    {6.7,3.1,4.4,1.4,1},
    {5.6,3.0,4.5,1.5,1},
    {5.8,2.7,4.1,1.0,1},
    {6.2,2.2,4.5,1.5,1},
    {5.6,2.5,3.9,1.1,1},
    {5.9,3.2,4.8,1.8,1},
    {6.1,2.8,4.0,1.3,1},
    {6.3,2.5,4.9,1.5,1},
    {6.1,2.8,4.7,1.2,1},
    {6.4,2.9,4.3,1.3,1},
    {6.6,3.0,4.4,1.4,1},
    {6.8,2.8,4.8,1.4,1},
    {6.7,3.0,5.0,1.7,1},
    {6.0,2.9,4.5,1.5,1},
    {5.7,2.6,3.5,1.0,1},
    {5.5,2.4,3.8,1.1,1},
    {5.5,2.4,3.7,1.0,1},
    {5.8,2.7,3.9,1.2,1},
    {6.0,2.7,5.1,1.6,1},
    {5.4,3.0,4.5,1.5,1},
    {6.0,3.4,4.5,1.6,1},
    {6.7,3.1,4.7,1.5,1},
    {6.3,2.3,4.4,1.3,1},
    {5.6,3.0,4.1,1.3,1},
    {5.5,2.5,4.0,1.3,1},
    {5.5,2.6,4.4,1.2,1},
    {6.1,3.0,4.6,1.4,1},
    {5.8,2.6,4.0,1.2,1},
    {5.0,2.3,3.3,1.0,1},
    {5.6,2.7,4.2,1.3,1},
    {5.7,3.0,4.2,1.2,1},
    {5.7,2.9,4.2,1.3,1},
    {6.2,2.9,4.3,1.3,1},
    {5.1,2.5,3.0,1.1,1},
    {5.7,2.8,4.1,1.3,1},
    {6.3,3.3,6.0,2.5,2},
    {5.8,2.7,5.1,1.9,2},
    {7.1,3.0,5.9,2.1,2},
    {6.3,2.9,5.6,1.8,2},
    {6.5,3.0,5.8,2.2,2},
    {7.6,3.0,6.6,2.1,2},
    {4.9,2.5,4.5,1.7,2},
    {7.3,2.9,6.3,1.8,2},
    {6.7,2.5,5.8,1.8,2},
    {7.2,3.6,6.1,2.5,2},
    {6.5,3.2,5.1,2.0,2},
    {6.4,2.7,5.3,1.9,2},
    {6.8,3.0,5.5,2.1,2},
    {5.7,2.5,5.0,2.0,2},
    {5.8,2.8,5.1,2.4,2},
    {6.4,3.2,5.3,2.3,2},
    {6.5,3.0,5.5,1.8,2},
    {7.7,3.8,6.7,2.2,2},
    {7.7,2.6,6.9,2.3,2},
    {6.0,2.2,5.0,1.5,2},
    {6.9,3.2,5.7,2.3,2},
    {5.6,2.8,4.9,2.0,2},
    {7.7,2.8,6.7,2.0,2},
    {6.3,2.7,4.9,1.8,2},
    {6.7,3.3,5.7,2.1,2},
    {7.2,3.2,6.0,1.8,2},
    {6.2,2.8,4.8,1.8,2},
    {6.1,3.0,4.9,1.8,2},
    {6.4,2.8,5.6,2.1,2},
    {7.2,3.0,5.8,1.6,2},
    {7.4,2.8,6.1,1.9,2},
    {7.9,3.8,6.4,2.0,2},
    {6.4,2.8,5.6,2.2,2},
    {6.3,2.8,5.1,1.5,2},
    {6.1,2.6,5.6,1.4,2},
    {7.7,3.0,6.1,2.3,2},
    {6.3,3.4,5.6,2.4,2},
    {6.4,3.1,5.5,1.8,2},
    {6.0,3.0,4.8,1.8,2},
    {6.9,3.1,5.4,2.1,2},
    {6.7,3.1,5.6,2.4,2},
    {6.9,3.1,5.1,2.3,2},
    {5.8,2.7,5.1,1.9,2},
    {6.8,3.2,5.9,2.3,2},
    {6.7,3.3,5.7,2.5,2},
    {6.7,3.0,5.2,2.3,2},
    {6.3,2.5,5.0,1.9,2},
    {6.5,3.0,5.2,2.0,2},
    {6.2,3.4,5.4,2.3,2},
    {5.9,3.0,5.1,1.8,2}], Layout);

//Add ID to each record
ML_Core.AppendSeqId(ds, id, DSIrisWId);
//Transform the raw data into Machine Learning Dataframe:
//ML_Core.Types.NumericField
ML_Core.ToField(DSIrisWId, DSIrisWIdWi);
//Define d01: training samples
d01 := DSIrisWIdWi(number < 5); //Filter unnecessary attribute not used for clustering
//Define d02: initial centroids
//Three centroids are initialized with 0, 1, 2 as its id respectively
ids := [1,51,101];
d02 := PROJECT(d01(id IN ids),TRANSFORM(Types.NumericField,
                                        SELF.id := MAP( LEFT.id = 1   => 0,
                                                        LEFT.id = 51  => 1, 2),
                                        SELF := LEFT));
//Set up the parameters
max_iteratons := 30;
tolerance := 0.0;
//Train KMeans model with the samples d01 and the centroids d02
Model := KMeans.KMeans(max_iteratons, tolerance).fit(d01, d02);
//Coordinates of cluster centers
Centroids := KMeans.KMeans().Centers(Model);
OUTPUT(Centroids);
//Number of iterations run
Total_Iterations := KMeans.KMeans().iterations(Model);
OUTPUT(Total_Iterations);
//Labels of each training sample
Labels := KMeans.KMeans().Labels(Model);
OUTPUT(Labels);
