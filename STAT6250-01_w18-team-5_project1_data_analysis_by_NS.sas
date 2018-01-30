*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding education levels in the USA subset on County levels

Dataset Name: Education_analytic_file created in external file
STAT6250-01_w18-team-5_project1_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that generates analytic dataset Education_analytic_file;
%include '.\STAT6250-01_w18-team-5_project1_data_preparation.sas';



title1
'Research Question: What is the average of adults population attained Bachelor Degree or higher for each state (2011-2015)?'
;

title2
'Rationale: This provides the average education level of adults attained Bachelor Degree or higher(2011-2015) for each state.'
;

footnote1
'Report reflects the average of educational level in Bachelor Degree or higher, grouped by Counties for each state in (2011-2015)'
;

*
Methodology: First, I use if statements to delete all those observations using 
column 'Area_Name' which has country name(United State) and States(excluding 
Counties).This will calculate an accurate SUM for each state, else averages 
will calculate inaccurate (that includes States and Country(U.S.A) data along 
with Counties data). Then next use proc means to calculate average number of 
adults grouped by county for per state who have achieved the specified 
level of educational level i.e Bachelor Degree or higher, of USA population 
for 2011-2015 using column "CH2011_15" in the temporary dataset.

Limitations: Current report reflects average for only 2011-2015, however 
by including the last three to five decades could provide better comparison 
of U.S.A adult's educational growth for each State. 

Possible Follow-up Steps: The way I tried to delete the observations of 
Country and States through SAS coding, need more research to delete the 
same in a more efficient way. Performance tuning of code needs to take care,
if any.
;
data Education_temp;
    set Work.Education_analytic_file;
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
    then delete
    ;
run;
proc means
        mean
            data = Education_temp nonobs
    ;
    var
        CH2011_15
    ;
    class
        State
    ;
    output out=Education_temp1
    mean = AVGEDU
    ;
run;
title;
footnote;




title1
'Research Question: Which State is the most well-educated who attained Bachelor Degree or higher (2011-2015)?'
;

title2
'Rationale: This would help us to know the top well-educated state in USA for the year (2011-2015).'
;

footnote1
'Now we see the most well educated state i.e "DC", attained the Bachelor Degree or higher educational level(2011-2015).'
;

*
Methodology: Once we got the Mean for each state(from above),now will compute
highest mean from all States to know which state scored highest in 
education level in attaining Bachelor's degree or higher (2011-2015).

Limitation: Current report reflects average of 'CH2011_15' for only 2011-2015,
however it did not include the last three to five decades which could provide 
better comparison of U.S.A adult's educational growth for each state, because 
growth in education impacts the growth in economic development.

Possible Follow-up Steps: Formatting is required such as label the columns 
with meaningful name(Customizing column name) if possible without changing 
column labels in dataset preparation file using SAS code. 
Performance tuning of code needs to take care, if any. 
;
proc sort
        data=Education_temp1
        out=Education_max
    ;
    by descending AVGEDU
    ;
run;
proc print
        noobs 
            data=Education_max
    ;
    var
        State 
        AVGEDU
    ;
run;
title;
footnote;




title1
'Research Question: How far Texas is deviated from the most well educated state i.e "DC".'
;

title2
'Rationale: This determines how far Texas is behind from District of Colombia in attaining higher education.'
;

footnote1
'Report depicts the comparison between two states (District of Colombia and Texas) of adults average population who attained Bachelor Degree or higher (2011-2015).'
;
 
*
Methodology: Using temporary data file from previous step, select average 
value of adults from Texas(TX) and District of Colombia(DC) using 
proc sql procedure.

Limitations: This report has chosen state Texas for comparison, without
taking any consideration of choosing any state with 1st or 3rd quartiles
or median of total average from the available states in the dataset.

Possible Follow-up Steps: For future step, determining the 1st/3rd quartile
or median of mean column(AVGEDU)for comparing with the most well educated
State. Performance tuning needs to take care, if any. 
;
proc sql
    ;
        select
            State, 
            AVGEDU
        from
            Education_max
        where
            State EQ 'TX' or 
            State EQ 'DC'
;
quit; 
title;
footnote;


