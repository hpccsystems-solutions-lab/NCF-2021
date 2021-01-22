IMPORT Std;
//IMPORT * FROM LanguageExtensions;

#WORKUNIT('name', 'Child Records');
#OPTION('pickBestEngine', FALSE);

//-----------------------------------------------------------------------------

PersonNameLayout := RECORD
    UNSIGNED1   guid;
    STRING      first_name;
    STRING      last_name;
END;

PersonLayout := RECORD
    PersonNameLayout;
    UNSIGNED1   shared_id;
END;

ds := DATASET
    (
        [
            {1, 'MALCOLM', 'REYNOLDS', 1},
            {2, 'ZOE', 'WASBHURNE', 2},
            {3, 'HOBAN', 'WASBHURNE', 2},
            {4, 'INARA', 'SERRA', 1},
            {5, 'JAYNE', 'COBB', 3},
            {6, 'KAYLEE', 'FRYE', 4},
            {7, 'SIMON', 'TAM', 4},
            {8, 'RIVER', 'TAM', 5},
            {9, 'DERRIAL', 'BOOK', 6}
        ],
        PersonLayout
    );

PairedLayout := RECORD
    UNSIGNED1           shared_id;
    PersonNameLayout    first_person;
    PersonNameLayout    second_person;
END;

paired := JOIN
    (
        ds,
        ds,
        LEFT.shared_id = RIGHT.shared_id AND LEFT.guid < RIGHT.guid,
        TRANSFORM
            (
                PairedLayout,
                SELF.first_person := LEFT,
                SELF.second_person := RIGHT,
                SELF := LEFT
            )
    );

OUTPUT(paired, NAMED('paired_people'));

OUTPUT(paired[1].first_person.first_name, NAMED('first_first_name'));
OUTPUT(paired[1].first_person.last_name, NAMED('first_last_name'));
