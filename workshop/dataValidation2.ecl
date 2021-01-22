IMPORT Std;
IMPORT DataPatterns;

#WORKUNIT('name', 'Stock Data Validate');

//-----------------------------------------------------------------------------

RawLayout := RECORD
    STRING trade_date;
    STRING exchange_code;
    STRING stock_symbol;
    STRING opening_price;
    STRING high_price;
    STRING low_price;
    STRING closing_price;
    STRING shares_traded;
    STRING share_value;
END;

ds := DATASET
    (
        '~demo::stock_data.txt',
        RawLayout,
        CSV(SEPARATOR('\t'), HEADING(1))
    );

// Append validation check result fields to the record
ValidatedLayout := RECORD
    RawLayout;
    BOOLEAN     is_trade_date_yyyymmdd;
    BOOLEAN     is_exchange_code_non_empty;
    // TODO: add more validation check fields
    BOOLEAN     is_valid;                   // summary check
END;

// Set values for validation fields
validatedDS := PROJECT
    (
        ds,
        TRANSFORM
            (
                ValidatedLayout,
                SELF.is_trade_date_yyyymmdd := LENGTH(LEFT.trade_date) = 8
                                                AND (UNSIGNED4)LEFT.trade_date BETWEEN 20020101 AND 20181101,
                SELF.is_exchange_code_non_empty := LENGTH(LEFT.exchange_code) > 0,
                // TODO: assign more validation checks; remember to update SELF.is_valid!
                SELF.is_valid := SELF.is_trade_date_yyyymmdd
                                    AND SELF.is_exchange_code_non_empty,
                SELF := LEFT
            )
    );

// Show some diagnostics
OUTPUT(ds, NAMED('original_sample'));
OUTPUT(COUNT(ds), NAMED('original_cnt'));

OUTPUT(validatedDS(is_valid), NAMED('valid_sample'));
OUTPUT(COUNT(validatedDS(is_valid)), NAMED('valid_cnt'));

OUTPUT(validatedDS(NOT is_valid), NAMED('invalid_sample'));
OUTPUT(COUNT(validatedDS(NOT is_valid)), NAMED('invalid_cnt'));
