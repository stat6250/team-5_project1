*******************************************************************************;
****************** Added an 80-character banner for reference *****************;
*******************************************************************************;

*
STAT6250-01_w18-team-5_project1_data_preparation.sas

This file loads the data set to be used in our analysis.

[Dataset Name] County-Level

[Experimental Units] United States Education Attainment

[Number of Observations] 3283

[Number of Features] 47

[Data Source] The file was downloaded from an external website at
https://www.ers.usda.gov/webdocs/DataFiles/48747/Education.xls?v=42762 and was
then edited to remove the top four lines and to add better titles for column
names.

[Data Dictionary] https://www.ers.usda.gov/data-products/county-level-data-sets/county-level-data-sets-download-data/

All measures related to educational attainment refer to the number of adults
who have achieved the specified level of educational attainment according
to the census year. For example, "High school diploma only, 1970" refers to
the number of adults who reported on the 1970 census that they achieved a high
school diploma and did not achieve any higher degrees.

Column header key:
FIPS_Code       FIPS Code (five digit code that uniquely identifies US counties)
State           State
Area_name       Area name (name of country, state, or county)
RUCC2003        2003 Rural-urban Continuum Code (lower is more urban)
UIC2003         2003 Urban Influence Code (lower is more urban)
RUCC2013        2013 Rural-urban Continuum Code
UIC2013         2013 Urban Influence Code
LHS1970         Less than a high school diploma, 1970
HS1970          High school diploma only, 1970
C13Y1970        Some college (1-3 years), 1970
CH1970          Four years of college or higher, 1970
PerLHS1970      Percent of adults with less than a high school diploma, 1970
PerHS1970       Percent of adults with a high school diploma only, 1970
PerC13Y1970     Percent of adults completing some college (1-3 years), 1970
PerCH1970       Percent of adults completing four years of college or higher, 1970
LHS1980         Less than a high school diploma, 1980
HS1980          High school diploma only, 1980
C13Y1980        Some college (1-3 years), 1980
CH1980          Four years of college or higher, 1980
PerLHS1980      Percent of adults with less than a high school diploma, 1980
PerHS1980       Percent of adults with a high school diploma only, 1980
PerC13Y1980     Percent of adults completing some college (1-3 years), 1980
PerCH1980       Percent of adults completing four years of college or higher, 1980
LHS1990         Less than a high school diploma, 1990
HS1990          High school diploma only, 1990
C13Y1990        Some college or associate's degree, 1990
CH1990          Bachelor's degree or higher, 1990
PerLHS1990      Percent of adults with less than a high school diploma, 1990
PerHS1990       Percent of adults with a high school diploma only, 1990
PerC13Y1990     Percent of adults completing some college or associate's degree, 1990
PerCH1990       Percent of adults with a bachelor's degree or higher, 1990
LHS2000         Less than a high school diploma, 2000
HS2000          High school diploma only, 2000
C13Y2000        Some college or associate's degree, 2000
CH2000          Bachelor's degree or higher, 2000
PerLHS2000      Percent of adults with less than a high school diploma, 2000
PerHS2000       Percent of adults with a high school diploma only, 2000
PerC13Y2000     Percent of adults completing some college or associate's degree, 2000
PerCH2000       Percent of adults with a bachelor's degree or higher, 2000
LHS2011_15      Less than a high school diploma, 2011-2015
HS2011_15       High school diploma only, 2011-2015
C13Y2011_15     Some college or associate's degree, 2011-2015
CH2011_15       Bachelor's degree or higher, 2011-2015
PerLHS2011_15   Percent of adults with less than a high school diploma, 2011-2015
PerHS2011_15    Percent of adults with a high school diploma only, 2011-2015
PerC13Y2011_15  Percent of adults completing some college or associate's degree, 2011-2015
PerCH2011_15    Percent of adults with a bachelor's degree or higher, 2011-2015

[Unique ID Schema] The column "FIPS_Code" is a primary key.
;

*
Environmental setup
;

*
Create output formats
;

*
Setup environmental parameters
;

%let inputDatasetUrl = https://github.com/stat6250/team-5_project1/blob/master/Education.xls?raw=true
;

*
Load raw dataset over the wire
;

%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;

%loadDataIfNotAlreadyAvailable(
    education_raw,
    &inputDatasetUrl.,
    xls
)

*
Check raw dataset for duplicates with primary key
;

proc sort
        nodupkey
        data=education_raw
        dupout=education_raw_dups
        out=_null_
    ;
    by
        FIPS_Code
    ;
run;

*
Create a data file for Team 5 members to use for analysis questions, only
keeping columns and adding new measures that will be used by one or more
team members.

Since only county-level data will be used in analyses by Team 5, remove any
observations of non-counties (i.e. states, countries).
;

data education_analytic_file;
    set education_raw;
        urban_increase = (RUCC2013 - RUCC2003) * -1;
        change_PerLHS = PerLHS2011_15 - PerLHS2000;
        change_PerHS = PerHS2011_15 - PerHS2000;
        change_PerC13 = PerC13Y2011_15 - PerC13Y2000;
        change_PerCH = PerCH2011_15 - PerCH2000;
        pop2015 = LHS2011_15 + HS2011_15 + C13Y2011_15 + CH2011_15;
        pop2000 = LHS2000 + HS2000 + C13Y2000 + CH2000;
        change_pop2000_2015 = pop2015 - pop2000;
        perChange_pop2000_2015 = (change_pop2000_2015 / pop2000) * 100;
    ;
    if
        Area_name = 'United States' or Area_name = 'Alabama'
        or Area_name = 'Alaska' or Area_name = 'Arizona'
        or Area_name = 'California' or Area_name = 'Colorado'
        or Area_name = 'Connecticut' or Area_name = 'Delaware'
        or Area_name = 'Florida' or Area_name = 'Georgia'
        or Area_name = 'Hawaii' or Area_name = 'Idaho'
        or Area_name = 'Illinois' or Area_name = 'Indiana'
        or Area_name = 'Iowa' or Area_name = 'Kansas'
        or Area_name = 'Kentucky' or Area_name = 'Louisiana'
        or Area_name = 'Maine' or Area_name = 'Maryland'
        or Area_name = 'Massachusetts' or Area_name = 'Michigan'
        or Area_name = 'Minnesota' or Area_name = 'Mississippi'
        or Area_name = 'Missouri' or Area_name = 'Montana'
        or Area_name = 'Nebraska' or Area_name = 'Nevada'
        or Area_name = 'New Hampshire' or Area_name = 'New Jersey'
        or Area_name = 'New Mexico' or Area_name = 'New York'
        or Area_name = 'North Carolina' or Area_name = 'North Dakota'
        or Area_name = 'Ohio' or Area_name = 'Oklahoma'
        or Area_name = 'Oregon' or Area_name = 'Pennsylvania'
        or Area_name = 'Rhode Island' or Area_name = 'South Carolina'
        or Area_name = 'South Dakota' or Area_name = 'Tennessee'
        or Area_name = 'Texas' or Area_name = 'Utah'
        or Area_name = 'Vermont' or Area_name = 'Virginia'
        or Area_name = 'Washington' or Area_name = 'West Virginia'
        or Area_name = 'Wisconsin' or Area_name = 'Wyoming'
        or Area_name = 'Puerto Rico'
    then
        delete
    ;
    retain
        FIPS_Code
        State
        Area_name
        RUCC2003
        RUCC2013
        CH2011_15
        PerCH2011_15
        LHS2011_15
        C13Y2011_15
        HS2011_15
        urban_increase
        change_PerLHS
        change_PerHS
        change_PerC13
        change_PerCH
        pop2015
        pop2000
        change_pop2000_2015
        perChange_pop2000_2015
    ;
    keep
        FIPS_Code
        State
        Area_name
        RUCC2003
        RUCC2013
        CH2011_15
        PerCH2011_15
        LHS2011_15
        C13Y2011_15
        HS2011_15
        urban_increase
        change_PerLHS
        change_PerHS
        change_PerC13
        change_PerCH
        pop2015
        pop2000
        change_pop2000_2015
        perChange_pop2000_2015
    ;
run;



*
Create data file for use in analysis by JB
;

data Education_JB1;
	set Education_analytic_file;
run;

proc sort data=Education_JB1;
    by descending urban_increase RUCC2013 descending RUCC2003;
run;



*
Create data files for use in analysis by NS
;

*
The data set Education_NS1 will also be resorted and used by WH
;

proc means
        noprint
        mean
        data = Education_analytic_file
        nonobs
    ;
    var
        CH2011_15
    ;
    class
        State
    ;
    output
        out=Education_NS0
        mean = AVGEDU
    ;
run;

data Education_NS1;
    set Work.Education_NS0;
    if
        _TYPE_ = 0
    then
        delete;
    ;
run;

proc sort
        data=Education_NS1
        out=Education_NS2
    ;
    by descending
        AVGEDU
    ;
run;



*
Create files for use in analysis by WH
;

data
        Education_WH3
    ;
    set
        Education_analytic_file
    ;
    if
        State ^= 'CA'
    then
        delete
    ;
    rename
        AREA_NAME=County
	CH2011_15=Adults_with_Bachelor_or_above
    ;
run;

proc sort
        data=Education_WH3
	out=Education_WH1
    ;
    by descending
        CH2011_15
    ;
run;

proc sort
        data=Education_NS1
        out=Education_WH2
    ;
    by
        AVGEDU
    ;
    format
        AVGEDU 8.2
    ;
run;
