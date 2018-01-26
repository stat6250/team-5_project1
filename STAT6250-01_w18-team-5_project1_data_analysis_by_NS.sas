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
%include '.\STAT6250-02_s17-team-5_project1_data_preparation.sas';

title1
'Research Question: What are the averages of adults attaining BachelorDegree or higher for each state for the period 2011-2015?';

title2
'Rationale: This will provide the average educational level of BachelorDegree or higher (2011-2015) for each state.';

footnote1
'It appears the average of educational level for BachelorDegree or higher, grouped by state for 2011-2015';

*
Methodology: First use If statements to Delete all those observations using 
column 'Area_Name' which has country name(United State) and States(excluding counties).
This way will claculate on actual total(sum) of each state, else average was calculating 
incorrectly by including State and Country data alog with conuties data). 

Then Use PROC MEANS to calculate average of educational level 
ie 'Bachelor's degree or higher, 2011-2015 of adults for each 
state in the temporary dataset.

Limitations: 

Possible Follow-up Steps: The way data has been manupulated through SAS receipe, 
need more research to delete observations based on condition in more appropriate way.
; 

DATA Education_temp;
	set Work.Education_analytic_file;
    IF Area_name = 'United States' OR Area_name = 'Alabama' OR Area_name = 'Alaska'
    OR Area_name = 'Arizona' OR Area_name = 'California' OR Area_name = 'Colorado' 
    OR Area_name = 'Connecticut' OR Area_name = 'Delaware' OR Area_name = 'Florida'
    OR Area_name = 'Georgia' OR Area_name = 'Hawaii' OR Area_name = 'Idaho' 
    OR Area_name = 'Illinois' OR Area_name = 'Indiana' OR Area_name = 'Iowa' 
    OR Area_name = 'Kansas' OR Area_name = 'Kentucky' OR Area_name = 'Lousiana' 
    OR Area_name = 'Maine' OR Area_name = 'Maryland' OR Area_name = 'Massachusetts' 
    OR Area_name = 'Michigan' OR Area_name = 'Minnesota' OR Area_name = 'Mississippi' 
    OR Area_name = 'Missouri' OR Area_name = 'Montana' OR Area_name = 'Nebraska' 
    OR Area_name = 'Nevada' OR Area_name = 'New Hampshire' OR Area_name = 'New Jersey' 
    OR Area_name = 'New Mexico' OR Area_name = 'New York' OR Area_name = 'North Carolina' 
    OR Area_name = 'North Dakota' OR Area_name = 'Ohio' OR Area_name = 'Oklahoma' 
    OR Area_name = 'Oregon' OR Area_name = 'Pennsylvania' OR Area_name = 'Rhode Island' 
    OR Area_name = 'South Carolina' OR Area_name = 'South Dakota' OR Area_name = 'Tennessee' 
    OR Area_name = 'Texas' OR Area_name = 'Utah' OR Area_name = 'Vermont' 
    OR Area_name = 'Virginia' OR Area_name = 'Washington' OR Area_name = 'West Virginia' 
    OR Area_name = 'Wisconsin' OR Area_name = 'Wyoming' OR Area_name = 'Puerto Rico' THEN DELETE;
RUN;
 
proc means mean data = Education_temp  nonobs;
var CH2011_15; 
class State; 
run; 
title;
footnote;


title1
'Research Question: Which is the most well-educated state having a bachelor or 
higher for 2011-2015?';

title2
'Rationale: This would help us to know the top well-educated state in the USA.';

footnote1
'We see the most well educated state for 2011-2015, attaining Bachelors degree or higher';

*
Methodology: Once we got the Mean for each state, now will compute Maximum
of Output Mean from all States to know which state scored highest in education 
level for column 'CH2011_15'(Bachelor's degree or higher, 2011-2015).

Limitation: 
Possible Follow-up Steps: Desirable output Do NOT met, Since 
;
PROC SORT DATA = Education_temp OUT = Education_max;
BY Mean;
run;
*proc means max data=Education_temp nonobs;
*var CH2011_15; 
*class State; 
*output out=Education_max_temp 
*max=Mean; 
*run; 
 
title;
footnote;

*proc means data=clinic.diabetes;
*var age height weight;
*class sex;
*output out=work.sum_gender
*mean=AvgAge AvgHeight AvgWeight
*min=MinAge MinHeight MinWeight;
*run; 
*proc print data=work.sum_gender;
*run;  


title1
'Research Question: What is the mean data of state Texas in attaining educated in 
bachelor or higher degree using column "Bachelordegree_higher_2011_2015" and How much state Texas 
is deviated from the well educated state';

title2
'Rationale: This would help determine the how mech Texas is deviated from the most well educated.';


;
*
Methodology: Printing the average(Mean) value of State Texas.
;

proc print noobs data=Education_temp where state EQ 'TX';
     var State CH2011_15;
run;


