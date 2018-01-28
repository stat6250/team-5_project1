*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding education levels in the USA subset on County levels
Dataset Name: Education_analytic_file created in external file
STAT6250-02_s17-team-5_project1_data_preparation.sas, which is assumed to be
in the same directory as this file
See included file for dataset properties
;

* environmental setup
;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset Education_analytic_file;
%include '.\STAT6250-01_w18-team-5_project1_data_preparation.sas';

title1
'Research Question: Which county has the highest(maximum) education levels for California for the period 2011-2015?';

title2
'Rationale: This will provide me the maximum educational level of adults for California.';

footnote1
'It appears the  maximum educationa level for BachelorDegree or higher, grouped by California for 2011-2015';

*
Methodology: Use IF statement to remove rows where CH2011_15 would represent the whole state which would mislead where the 
maximum should be.  Then use PROC MEANS statement to fin max for each state. 

Limitations: This methodology does not account for districts with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: Compare the max by year
; 

DATA Education_temp;
    set Work.Education_analytic_file;
    IF Area_name = 'United States' OR Area_name = 'Alabama' 
    OR Area_name = 'Alaska' OR Area_name = 'Arizona' 
    OR Area_name = 'California' OR Area_name = 'Colorado' 
    OR Area_name = 'Connecticut' OR Area_name = 'Delaware' 
    OR Area_name = 'Florida' OR Area_name = 'Georgia' OR Area_name = 'Hawaii'
    OR Area_name = 'Idaho' OR Area_name = 'Illinois' OR Area_name = 'Indiana'
    OR Area_name = 'Iowa' OR Area_name = 'Kansas' OR Area_name = 'Kentucky' 
    OR Area_name = 'Lousiana' OR Area_name = 'Maine' OR Area_name = 'Maryland'
    OR Area_name = 'Massachusetts' OR Area_name = 'Michigan' 
    OR Area_name = 'Minnesota' OR Area_name = 'Mississippi' 
    OR Area_name = 'Missouri' OR Area_name = 'Montana' 
    OR Area_name = 'Nebraska' OR Area_name = 'Nevada' 
    OR Area_name = 'New Hampshire' OR Area_name = 'New Jersey' 
    OR Area_name = 'New Mexico' OR Area_name = 'New York' 
    OR Area_name = 'North Carolina' OR Area_name = 'North Dakota' 
    OR Area_name = 'Ohio' OR Area_name = 'Oklahoma'  
    OR Area_name = 'Oregon' OR Area_name = 'Pennsylvania' 
    OR Area_name = 'Rhode Island' OR Area_name = 'South Carolina' 
    OR Area_name = 'South Dakota' OR Area_name = 'Tennessee' 
    OR Area_name = 'Texas' OR Area_name = 'Utah' OR Area_name = 'Vermont' 
    OR Area_name = 'Virginia' OR Area_name = 'Washington' 
    OR Area_name = 'West Virginia' OR Area_name = 'Wisconsin' 
    OR Area_name = 'Wyoming' OR Area_name = 'Puerto Rico' THEN DELETE;
RUN;
 
DATA Education_CA;
    Set Education_Temp;
	IF  State ^= 'CA' THEN DELETE;
RUN;
PROC MEANS data = Education_CA max;
	var CH2011_15;
RUN; 

title;
footnote;


title1
'Research Question: Which is the least educated state using column Less than a High School Diploma, 2011-2015?';


title2
'Rationale: This would help us to know the least educated state in the USA.';


footnote1
'Now we see the least educated state who got Bachelors or higher (2011-2015).';
*
Methodology: Compute lowest mean of State of indicator variable

Limitations: This methodology does not account for any States with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values of the variable
Bachelordegree_higher_2011_2015 so that the statistics computed do not include any
possible illegal values, and better handle missing data.
;

PROC MEANS mean data = Education_temp  nonobs;
   var CH2011_15; 
   class State;
   output out=Education_avg mean = AVGGRAD;
RUN; 

PROC SORT DATA = Education_avg OUT = Education_min;
    BY AVGGRAD;
RUN;
PROC PRINT noobs data=Education_min (obs=3);
   var State AVGGRAD;
RUN;


title1
'Research Question: What is the distribution of education in the state of California by using colum 
"Bachelor Degree or Higher, 2011-2015" by counties;

title2
'Rationale: This would help determine how California's eduation level is.';


*
Methodology: Create new dateset with only CA data. Then plot scatter plot graph to show variable CH2011_15 by county name.

Limitations: This methodology does not account for any States with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: Expand it to other education level.
;

DATA Education_CA;
    set Education_temp;
    IF State ne 'CA' then DELETE;
RUN;

PROC GPLOT data = Education_CA;
    TITLE 'California Education Analysis by counties';
    PLOT CH2011_15*AREA_NAME;
    AXIS1 ORDER = (0 to 25000000 by 10000);
RUN;




