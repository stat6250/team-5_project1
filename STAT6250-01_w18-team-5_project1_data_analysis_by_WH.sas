*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several researches
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
'Research Question: Which county has the highest(maximum) education levels for California for the period 2011-2015?'
;

title2
'Rationale: This will provide me the maximum educational level of adults for California.'
;

footnote1
'It shows that the  maximum educational level for Bachelor Degree or higher, grouped by California for 2011-2015'
;
*
Methodology: Use IF statement to remove rows where CH2011_15 would 
represent the whole state which would mislead where the maximum should be.
Then use PROC MEANS statement to fin max for each state. 

Limitations: This methodology does not account for districts with 
missing data, nor does it attempt to validate data in any way.

Possible Follow-up Steps: Compare the max by year
; 

data
        Education_temp
    ;
    set
        Work.Education_analytic_file
    ;
    IF
        Area_name = 'United States' or Area_name = 'Alabama' 
        or Area_name = 'Alaska' or Area_name = 'Arizona' 
        or Area_name = 'California' or Area_name = 'Colorado' 
        or Area_name = 'Connecticut' or Area_name = 'Delaware' 
        or Area_name = 'Florida' or Area_name = 'Georgia' or Area_name = 'Hawaii'
        or Area_name = 'Idaho' or Area_name = 'Illinois' or Area_name = 'Indiana'
        or Area_name = 'Iowa' or Area_name = 'Kansas' or Area_name = 'Kentucky' 
        or Area_name = 'Lousiana' or Area_name = 'Maine' or Area_name = 'Maryland'
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
        or Area_name = 'Texas' or Area_name = 'Utah' or Area_name = 'Vermont' 
        or Area_name = 'Virginia' or Area_name = 'Washington' 
        or Area_name = 'West Virginia' or Area_name = 'Wisconsin' 
        or Area_name = 'Wyoming' or Area_name = 'Puerto Rico'
    then
        delete
    ;
run;
data
        Education_CA
    ;
    set
        Education_Temp
    ;
    if
        State ^= 'CA'
    then
        delete
    ;
run;
proc means
        data = Education_CA max
    ;
    var
        CH2011_15
    ;
run; 
title;
footnote;



title1
'Research Question: Which is the least educated state using column Less than a High School Diploma, 2011-2015?'
;

title2
'Rationale: This would help us to know the least educated state in the USA.'
;

footnote1
'Now we see the least educated state who got Bachelor''s or higher (2011-2015).'
;
*
Methodology: Compute lowest mean of State of indicator variable

Limitations: This methodology does not account for any States 
with missing data, nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values 
of the variable Bachelordegree_higher_2011_2015 so that the 
statistics computed do not include any possible illegal values,
and better handle missing data.
;
proc means
        mean
	data = Education_temp
	nonobs
    ;
    var
        CH2011_15
    ; 
    class
        State
    ;
    output
        out=Education_avg
        mean = AVGGRAD
    ;
run; 
proc sort
        data = Education_avg
	OUT = Education_min
    ;
    BY
        AVGGRAD
    ;
RUN;
PROC PRINT
        noobs
	DATA=Education_min (obs=3)
    ;
    var
        State
	AVGGRAD
    ;
run;
title;
footnote;



title1
'Research Question: What is the distribution of education in the state of California by using column Bachelor Degree or Higher, 2011-2015 by counties'
;

title2
'Rationale: This would help determine how California''s eduation level is.'
;
*
Methodology: Create new dataset with only CA data. 
Then plot scatter plot graph to show variable CH2011_15 by county name.

Limitations: This methodology does not account for any States 
with missing data, nor does it attempt to validate data in any way.

Possible Follow-up Steps: Expand it to other education level.
;
data
        Education_CA
    ;
    set
        Education_temp
    ;
    IF
        State ^= 'CA'
    then
        delete
    ;
run;
proc gplot 
        data = Education_CA
    ;
    title
        'California Education Analysis by counties'
    ;
    plot
        CH2011_15*AREA_NAME
    ;
        axis1 order = (0 to 25000000 by 10000);
run;
title;
footnote;



