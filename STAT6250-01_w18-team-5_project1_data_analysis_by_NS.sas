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
'Research Question: What are the averages of adults attaining BachelorDegree or higher for each state (2011-2015?)';

title2
'Rationale: This provides the average education level of adults in BachelorDegree or higher(2011-2015) for each state.';

footnote1
'It appears the average of educationa level for BachelorDegree or higher, grouped by state for 2011-2015';

*
Methodology: First use If statements to DELETE all those observations using 
column 'Area_Name' which has country name(United State) and States(excluding 
counties).This will calculate an accurae SUM for each state, else 
averages will calculate inacurate (that includes State and Country data along 
with Counuty data). 

Then next Use PROC MEANS to calculate average of education level 
ie 'Bachelor's degree or higher, 2011-2015 of adults for each 
state in the temporary dataset.

Limitations: This output did not includes more variables other than 'CH2011_15'.
This report can be more useful if we compare other columns(Variables).

Possible Follow-up Steps: The way I tried to DELETE the observations of 
Country and State through SAS coding, need more research to delete the 
same in a more efficent way.
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
 
proc means mean data = Education_temp  nonobs;
var CH2011_15; 
class State;
output out=Education_temp1 mean = AVGEDU;
run; 
title;
footnote;


title1
'Research Question: Which State is the most well-educated in attaining bachelor or higher Degree (2011-2015)?';

title2
'Rationale: This would help us to know the top well-educated state in the USA.';

footnote1
'Now we see the most well educated state attaining Bachelors or higher degree(2011-2015).';

*
Methodology: Once we got the Mean for each state(from above),now will compute
highest mean from all States to know which state scored highest in 
education level in attaining Bachelor's degree or higher(2011-2015).

Limitation: Output did not includes more variables other than 'CH2011_15'.
This report can be more useful if we compare other columns(Variables).  

Possible Follow-up Steps: Formating is required such as label the columns 
with meaningful name etc. 
;

PROC SORT DATA = Education_temp1 OUT = Education_max;
BY decending AVGEDU;
run;
proc print noobs data=Education_max;
var State AVGEDU;
run;

title;
footnote;


title1
'Research Question: How far Texas is deviated from the most well educated state i.e "DC".';

title2
'Rationale: This determines how far Texas is behind from District of Colombia in attaining education.';
;
*
Methodology: Using data file from previous step, select Averagevalue of adults 
from Texas by using PROC SQL...QUIT procedure.

Limitations: If we want to see the Educational attainment for adults age 25 
and older for the U.S., States, and counties(1970-2015. Output did not 
includes more variables other than 'CH2011_15'.This report can be more 
useful if we compare other columns(Variables). , 

Possible Follow-up Steps: Formating is required such as label the columns 
with meaningful name etc. 
;


PROC SQL;
 SELECT State, AVGEDU
 FROM Education_max
 WHERE State EQ 'TX' OR 
       State EQ 'DC';
QUIT; 



