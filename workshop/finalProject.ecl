/* Submission Info

Maximum Team of two 
Due Monday Jan 25th @7 PM
Submission by email:  Bahareh.Fardanian@lexisnexisrisk.com
    - WUID
    - Team’s participants names

*/

//***************************************

/* Problem

I want to fly from Austin to Chicago sometime during the month of March, 2020. Exactly when is not important. 
During that trip, I want to visit some relatives during a brief overnight stay in Bloomington, IL. 
Output a dataset to the workunit where every record contains a flight that satisfies the following criteria Depart from Austin, TX airport (AUS) 
Arrive at the Bloomington/Normal airport in Illinois (BMI)

Hint: There will be one layover

For the connecting flight, I want to stay on the same airline because I want my bags to be transferred automatically 
The layover time should be no less than 1 hour and no more than 2 hours The very next day, before 10am, depart from the Bloomington/Normal airport and 
fly to O’Hare International Airport in Chicago (ORD) Only the record(s) matching the minimum sum total flight time + layover should be shown

*/

//**********************************

/* Hints

1- Filter down to the month you are after
2- Keep in mind what your final dataset should look like
3- Since you are building connections, you need to join gsec withself
4- Calculate depart or arrival time in min:
depart_minutes_after_midnight := ((UNSIGNED1)LEFT.DepartTimePassenger[1..2] * 60 + (UNSIGNED1)LEFT.DepartTimePassenger[3..4]);
5- Keep in mind your layover time is between one to two hours, so your operation day should be same day


sampleRec := RECORD
    STRING FirstName;
    STRING LastName;
END;

buildRec := RECORD
    RECORDOF(sampleRec) RecOne;
    RECORDOF(sampleRec) RecTwo;
    INTEGER val;
END;

*/


