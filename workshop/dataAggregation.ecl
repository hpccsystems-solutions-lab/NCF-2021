IMPORT $.getFlights;


// Find the average distance each carrier flies out of each airport by day of week
aveDistanceByCarrier := TABLE
    (
        getFlights.gsecData,
        {
            Carrier,
            FlightNumber,
            DepartCityCode,
            UNSIGNED2    dist_mon := AVE(GROUP, FlightDistance, IsOpMon = 1),
            UNSIGNED2    dist_tue := AVE(GROUP, FlightDistance, IsOpTue = 1),
            UNSIGNED2    dist_wed := AVE(GROUP, FlightDistance, IsOpWed = 1),
            UNSIGNED2    dist_thu := AVE(GROUP, FlightDistance, IsOpThu = 1),
            UNSIGNED2    dist_fri := AVE(GROUP, FlightDistance, IsOpFri = 1),
            UNSIGNED2    dist_sat := AVE(GROUP, FlightDistance, IsOpSat = 1),
            UNSIGNED2    dist_sun := AVE(GROUP, FlightDistance, IsOpSun = 1),
        },
        Carrier, FlightNumber, DepartCityCode
    );

OUTPUT(aveDistanceByCarrier, NAMED('aveDistanceByCarrier'));

/******************************************************************************
 * TODO
 *
 * Create new aggregations by applying TABLE against the GSEC data.
 *
 * ECL functions that will accept the GROUP keyword instead of a dataset --
 * which means they can be used within TABLE -- are as follows:
 *
 *      AVE()
 *      COUNT()
 *      MAX()
 *      MIN()
 *      SUM()
 *      VARIANCE()
 *      COVARIANCE()
 *      CORRELATION()
 ******************************************************************************/