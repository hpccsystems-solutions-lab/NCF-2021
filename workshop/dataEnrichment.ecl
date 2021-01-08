IMPORT $.getFlights;
IMPORT Std;


// Record structure including our appended fields
AppendedRec := RECORD
    getFlights.GSECRec;
    UNSIGNED4       schedule_duration_in_days;
    UNSIGNED4       depart_minutes_after_midnight;
    UNSIGNED4       arrive_minutes_after_midnight;
    // TODO: Add more fields
END;

// Iterate over the original dataset, applying the transform to each record
appendedData := PROJECT
    (
        getFlights.gsecData,
        TRANSFORM
            (
                AppendedRec,
                startedDate := Std.Date.FromStringToDate(LEFT.EffectiveDate, '%Y%m%d');
                stoppedDate := Std.Date.FromStringToDate(LEFT.DiscontinueDate, '%Y%m%d');
                SELF.schedule_duration_in_days := Std.Date.DaysBetween(startedDate, stoppedDate) + 1,
                // Note the substring operation, and casting of a string to an unsigned integer
                SELF.depart_minutes_after_midnight := ((UNSIGNED1)LEFT.DepartTimePassenger[1..2] * 60 + (UNSIGNED1)LEFT.DepartTimePassenger[3..4]),
                SELF.arrive_minutes_after_midnight := ((UNSIGNED1)LEFT.ArriveTimePassenger[1..2] * 60 + (UNSIGNED1)LEFT.ArriveTimePassenger[3..4]),
                // TODO: Assign values to the new fields
                SELF := LEFT
            )
    );

OUTPUT(appendedData, NAMED('appendedData'));

/*******************************************************************************
 * Std.Date datatypes
 *
 *  Std.Date.Date_t - numeric date in YYYYMMDD format
 *  Std.Date.Time_t - numeric time in HHMMSS format
 *
 * Std.Date functions
 *
 *  STD.Date.FromStringToDate(STRING s, STRING format)
 *  STD.Date.FromStringToTime(STRING s, STRING format)
 *  STD.Date.Year(Date_t d)
 *  STD.Date.Month(Date_t d)
 *  STD.Date.Day(Date_t d)
 *  STD.Date.Hour(Time_t t)
 *  STD.Date.Minute(Time_t t)
 *  STD.Date.Second(Time_t t)
 *  STD.Date.DayOfWeek(Date)
 *  STD.Date.DayOfYear(date);
 *  STD.Date.DaysBetween(Date_t d1, Date_t d2)
 *  STD.Date.MonthsBetween(Date_t d1, Date_t d2)
 *  STD.Date.YearsBetween(Date_t d1, Date_t d2)
 *  STD.Date.Today();
 *  STD.Date.CurrentDate(Local_Time);
 *  STD.Date.CurrentTime(Local_Time);
 
 ******************************************************************************/