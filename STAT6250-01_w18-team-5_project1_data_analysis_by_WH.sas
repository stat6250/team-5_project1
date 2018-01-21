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


'Research Question: What is the highest(maximum) education levels
(column from the dataset) for each state for the period 2011-2015 using column 
BachelorDegree_higher_2011_2015?';

'Rationale: This will provide me the maximum educational level i.e BachelorDegree_higher_2011_2015
of adults for each state. This will provide an overall view of the top students across USA.';

*
Methodology: Use PROC MEAN to calculate maximum of educational level ie 'Bachelor's degree or higher, 2011-2015 of adults for each state?'
in the temporary dataset created in the corresponding data-prep file.

Limitations: This methodology does not account for districts with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values of the variable
'BachelorDegree_higher_2011_2015' of adults for each state
; 

proc means max data=Education_raw;
	class State;
	var  FIPS_Code State BachelorDegree_higher_2011_2015;
	output out=Education_temp;
 
run; 

proc print noobs data=Education_temp(obs=20);
     ID State
     var BachelorDegree_higher_2011_2015;
run;



'Research Question: Which is the least educated state using column Less than a High School Diploma, 2011-2015?';


'Rationale: This would help us to know the least educated state in the USA.';

*
Methodology: Compute lowest mean of State of indicator variable

Limitations: This methodology does not account for any States with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values of the variable
Bachelordegree_higher_2011_2015 so that the statistics computed do not include any
possible illegal values, and better handle missing data.
;

proc sort data=Education_temp;
by state;
run; 
proc print noobs data=Education_temp(obs=20);
     var State Lessthanadiploma_2011_2015;
run;


'Research Question: What is the distribution of education in the state of California by using colum "Bachelor Degree or Higher, 2011-2015"
 , "Some college or associate degree, 2011-2015", "High School Diploma Only, 2011-2015 and "Less than a high school diploma, 2011-2015"';


'Rationale: This would help determine how California's eduation level is.'
;
*
Methodology: Printing the average value of State of California.

Limitations: This methodology does not account for any States with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values of the variable
Bachelordegree_higher_2011_2015 so that the statistics computed do not include any
possible illegal values, and better handle missing data.
;

proc print noobs data=Education_temp where state EQ 'CA';
     var State BachelorDegree_higher_2011_2015, AssociateDegree_2011_2015, HighSchoolDiploma_2011_2015, LessthanHighSchoolDiploma_2011_2015;
run;



