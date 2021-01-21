IMPORT getFlights;

/* 
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

// Original GSEC data
gsecData := DATASET
    (
        '~flight::schedule_2019',   // Logical file pathname
        getFlights.GSECRec,              // Imported record definition
        FLAT                        // File type (FLAT = native Thor file format)
    );

gsecLimitedTimes := gsecData(EffectiveDate <= '20200331' AND DiscontinueDate >= '20200301');

gsecWithTimes := PROJECT
    (
        gsecLimitedTimes,
        TRANSFORM
            (
                {
                    getFlights.GSECRec.Carrier,
                    getFlights.GSECRec.FlightNumber,
                    getFlights.GSECRec.EffectiveDate,
                    getFlights.GSECRec.DiscontinueDate,
                    getFlights.GSECRec.IsOpMon,
                    getFlights.GSECRec.IsOpTue,
                    getFlights.GSECRec.IsOpWed,
                    getFlights.GSECRec.IsOpThu,
                    getFlights.GSECRec.IsOpFri,
                    getFlights.GSECRec.IsOpSat,
                    getFlights.GSECRec.IsOpSun,
                    getFlights.GSECRec.DepartStationCode,
                    getFlights.GSECRec.DepartTimePassenger,
                    getFlights.GSECRec.ArriveStationCode,
                    getFlights.GSECRec.ArriveTimePassenger,
                    getFlights.GSECRec.FlightDurationLessLayover,
                    UNSIGNED4   depart_minutes_after_midnight,
                    UNSIGNED4   arrive_minutes_after_midnight
                },
                SELF.depart_minutes_after_midnight := ((UNSIGNED1)LEFT.DepartTimePassenger[1..2] * 60 + (UNSIGNED1)LEFT.DepartTimePassenger[3..4]),
                SELF.arrive_minutes_after_midnight := ((UNSIGNED1)LEFT.ArriveTimePassenger[1..2] * 60 + (UNSIGNED1)LEFT.ArriveTimePassenger[3..4]),
                SELF := LEFT
            )
    );

leavingAustin := gsecWithTimes(DepartStationCode = 'AUS');
arrivingBloomington := gsecWithTimes(ArriveStationCode = 'BMI');
bmi2Chicago := gsecWithTimes(DepartStationCode = 'BMI' AND ArriveStationCode = 'ORD' AND DepartTimePassenger < '100000');

aus2BMIConnections := JOIN
    (
        leavingAustin,
        arrivingBloomington,
        LEFT.ArriveStationCode = RIGHT.DepartStationCode
            AND LEFT.Carrier = RIGHT.Carrier
            AND ((LEFT.EffectiveDate >= RIGHT.EffectiveDate AND LEFT.DiscontinueDate <= RIGHT.DiscontinueDate) OR (LEFT.EffectiveDate <= RIGHT.EffectiveDate AND LEFT.DiscontinueDate >= RIGHT.DiscontinueDate))
            AND ((LEFT.IsOpMon = 1 AND RIGHT.IsOpMon = 1) OR (LEFT.IsOpTue = 1 AND RIGHT.IsOpTue = 1) OR (LEFT.IsOpWed = 1 AND RIGHT.IsOpWed = 1) OR (LEFT.IsOpThu = 1 AND RIGHT.IsOpThu = 1) OR (LEFT.IsOpFri = 1 AND RIGHT.IsOpFri = 1) OR (LEFT.IsOpSat = 1 AND RIGHT.IsOpSat = 1) OR (LEFT.IsOpSun = 1 AND RIGHT.IsOpSun = 1))
            AND RIGHT.depart_minutes_after_midnight BETWEEN (LEFT.arrive_minutes_after_midnight + 60) AND (LEFT.arrive_minutes_after_midnight + 120),
        TRANSFORM
            (
                {
                    RECORDOF(gsecWithTimes)     leg_1,
                    RECORDOF(gsecWithTimes)     leg_2,
                    UNSIGNED4                   total_duration
                },
                SELF.total_duration := LEFT.FlightDurationLessLayover + RIGHT.FlightDurationLessLayover + (RIGHT.depart_minutes_after_midnight - LEFT.arrive_minutes_after_midnight),
                SELF.leg_1 := LEFT,
                SELF.leg_2 := RIGHT
            )
    );

allFlights := JOIN
    (
        aus2BMIConnections,
        bmi2Chicago,
        ((LEFT.leg_2.EffectiveDate >= RIGHT.EffectiveDate AND LEFT.leg_2.DiscontinueDate <= RIGHT.DiscontinueDate) OR (LEFT.leg_2.EffectiveDate <= RIGHT.EffectiveDate AND LEFT.leg_2.DiscontinueDate >= RIGHT.DiscontinueDate))
            AND ((LEFT.leg_2.IsOpMon = 1 AND RIGHT.IsOpTue = 1) OR (LEFT.leg_2.IsOpTue = 1 AND RIGHT.IsOpWed = 1) OR (LEFT.leg_2.IsOpWed = 1 AND RIGHT.IsOpThu = 1) OR (LEFT.leg_2.IsOpThu = 1 AND RIGHT.IsOpFri = 1) OR (LEFT.leg_2.IsOpFri = 1 AND RIGHT.IsOpSat = 1) OR (LEFT.leg_2.IsOpSat = 1 AND RIGHT.IsOpSun = 1) OR (LEFT.leg_2.IsOpSun = 1 AND RIGHT.IsOpMon = 1)),
        TRANSFORM
            (
                {
                    RECORDOF(gsecWithTimes)     leg_1,
                    RECORDOF(gsecWithTimes)     leg_2,
                    RECORDOF(gsecWithTimes)     leg_3,
                    STRING8                     effective_date,
                    STRING8                     discontinue_date,
                    UNSIGNED4                   total_duration
                },
                SELF.effective_date := MAX(LEFT.leg_1.EffectiveDate, LEFT.leg_2.EffectiveDate, RIGHT.EffectiveDate, '20200301'),
                SELF.discontinue_date := MIN(LEFT.leg_1.DiscontinueDate, LEFT.leg_2.DiscontinueDate, RIGHT.DiscontinueDate, '20200331'),
                SELF.total_duration := LEFT.total_duration + RIGHT.FlightDurationLessLayover,
                SELF.leg_1 := LEFT.leg_1,
                SELF.leg_2 := LEFT.leg_2,
                SELF.leg_3 := RIGHT
            ),
        ALL
    );

leastTimeFlights := allFlights(total_duration = MIN(allFlights, total_duration));

OUTPUT(leastTimeFlights, NAMED('leastTimeFlights'), ALL);
