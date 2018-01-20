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
'Research Question: What is the average(mean) of adults education levels
(columns from the dataset) for each state for the period 2011-2015 using column 
Bachelors degree or higher(2011_2015)?';

title2
'Rationale: This will provide me the average educational level, Bachelor's 
degree or higher (2011-2015) of adults for each state.';

footnote1
'Based on the above output, average of each States who has attained Bachelor's
degree or higher 2011-2015 in the United State.';

footnote2
'Moreover, we can see that virtually all of the top 10 well educated state, 
suggesting great contributor in economy growth.';

footnote3
'Further analysis to look for geographic patterns is clearly warrented, given
such high mean percentages of attainment.';

*
Methodology: Use PROC MEAN to calculate average of educational level ie 'Bachelor's degree or higher, 2011-2015 of adults for each state?'
in the temporary dataset created in the corresponding data-prep file.

Limitations: This methodology does not account for districts with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values of the variable
'Bachelor's degree or higher, 2011-2015' of adults for each state
; 
proc print data=Education;
run;

proc means mean data=Education n;
	class State;
	var FIPS_Code State BachelorDegree_higher_2011_2015;
	output out=Education_temp;
 
run; title1;

proc print
        noobs
        data=Education_analytic_file_temp(obs=20);
    id FIPS_Code;
    var State Bachelor_degreehigher_2011_2015;
run;

title2;
footnote1;



title1
'Research Question: Which is the most well-educated state having a bachelor or higher degree using column Bachelors degree or higher 2011-2015?';

title2
'Rationale: This would help us to know the top well-educated state in the USA.';

footnote1
'However, there is a strong corelation beteen education and economy growth, certainly high rate of employment is due to the high rate of education will affect the USA economy growth.';

footnote2
'However, Charter schools do appear to have slighly lower childhood poverty rates, overall, given the smaller first and second quartiles.';

footnote3
'However, there is a strong corelation beteen education and economy growth, certainly high rate of employment is due to the high rate of education will affect the USA economy growth.';

*
Methodology: Compute max of indicator variable

Limitations: This methodology does not account for any States with missing data,
nor does it attempt to validate data in any way.

Possible Follow-up Steps: More carefully clean the values of the variable
Bachelordegree_higher_2011_2015 so that the statistics computed do not include any
possible illegal values, and better handle missing data.
;

proc means 
        max
        data=Education_analytic_file;
    class States;
    var State Bachelordegree_higher_2011_2015;
    output out=Education_analytic_file_temp;
run;
title;
footnote;


title1
'Research Question: Which is the least educated state in bachelor or higher degree using column "Bachelordegree_higher_2011_2015"';

title2
'Rationale: This would help determine the lowest state in attaining education in USA, so that government can help them to get more education';

footnote1
'Based on the above output, ????????????????.';

footnote2
'However, there is a strong corelation beteen education and economy growth, certainly high rate of employment is due to the high rate of education will affect the USA economy growth.';
*
Methodology: Use proc means to study the five-number summary of each variable,
create formats to bin values of Enrollment_K12 and Percent_Eligible_FRPM_K12
based upon their spread, and use proc freq to cross-tabulate bins.

Limitations: Even though predictive modeling is specified in the research
questions, this methodology solely relies on a crude descriptive technique
by looking at correlations along quartile values, which could be too coarse a
method to find actual association between the variables.

Follow-up Steps: A possible follow-up to this approach could use an inferential
statistical technique like beta regression.
;
proc freq
        data=FRPM1516_analytic_file;
    table
        Enrollment_K12*Percent_Eligible_FRPM_K12
        / missing norow nocol nopercent;
    format
        Enrollment_K12 Enrollment_K12_bins.
        Percent_Eligible_FRPM_K12 Percent_Eligible_FRPM_K12_bins.;
run;
title;
footnote;
