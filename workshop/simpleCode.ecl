//Simple output
OUTPUT('My first ECL code', NAMED('testMe'));

//Let's add 2+2
OUTPUT(2 + 2, NAMED('simpleMath'));

//Let's output a variable 
calIt := (2 + 12) * 3;
str   := 'Result is: ';
OUTPUT(str + calIt);

//1- Display the following: 
//My random value is : -- and my fave day is Friday.
//Hint: use RANDOM() function to get a random value.

myRand := RANDOM();
OUTPUT('My random value is : ' +
        myRand +
        ' and my fave day is Friday.');


