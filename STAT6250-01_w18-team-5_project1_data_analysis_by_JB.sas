*******************************************************************************;

*
This file uses the following analytic data set to address several research
questions regarding educational attainment in each county and state in the
United States over several decades.

Data set name: Education_raw created in external file
STAT6250-01_w18-team-5_project1_data_preparation.sas, which is assumed to be
in the same directory as this file.

See the file referenced above for data set properties.
;

* environmental setup;

* set relative file import path to current directory;
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";

* load external file that generates analytic data set Education_raw;
%include '.\STAT6250-01_w18-team-5_project1_data_preparation.sas';

title1
'Research Question 1: Which counties in the United States have become significantly more urban between 2003 and 2013?'
;

title2
'Rationale: This may serve as a point of reference when comparing levels of educational attainment between those time periods.'
;

*
Methodology: Create a column that measures the change in Rural Urban
Continuum Code from 2003 to 2013, and which changes the difference to
a positive number to give the impression of an increase in how urban a
place is.

Then, sort the data to put the locations with the highest increase first,
then sorted by each locations most recent RUCC, and then by the older RUCC.

Then use PROC PRINT to show the states, areas, and RUCC values for the top
50 urbanized locations.
;
data Education_raw_temp;
	set Work.Education_raw;
        urban_increase = (RUCC2013 - RUCC2003) * -1;
run;

proc sort data=Education_raw_temp;
    by  descending urban_increase descending RUCC2013 descending RUCC2003;
run;

proc print
        noobs
            data = Education_raw_temp(obs=50)
    ;
    var
        State
        Area_name
        RUCC2003
        RUCC2013
        urban_increase
    ;
run;



