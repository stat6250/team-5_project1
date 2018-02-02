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
'Above result shows the average of educational level in Bachelor Degree or higher, grouped by Counties for each state in (2011-2015)'
;

*
Methodology: Use PROC PRINT to print the average number of 
adults grouped by county for per state who have achieved the specified 
level of educational level i.e Bachelor Degree or higher, of USA population 
for 2011-2015 using column "CH2011_15" in the temporary dataset.

Limitations: Current report reflects average for only 2011-2015, however 
by including the last three to five decades could provide better comparison 
of U.S.A adult's educational growth for each State.

Possible Follow-up Steps: This methodology does not account for any States 
with missing data, nor does it attempt to validate data in any way.
;
proc print 
        noobs 
        data=Education_NS1 (obs=20)
		LABEL
   ;
   label 
       AVGEDU = 'Average of Adults(USA) attained Bachelor Degree or higher(2011-2015)'
   ;
   format 
       AVGEDU 12.2
   ;
   var 
       State
	   AVGEDU
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
'Based on the above output, we have the top 5 most well educated state, attained the Bachelor Degree or higher educational level(2011-2015).'
;

footnote2
'Moreover, over the virtually top educated states, suggesting to encourage education facility to below average dorminant states.'
;

*
Methodology: Once we got the Mean for each state(from above),now will compute
highest mean from all States to know which state scored highest in 
education level in attaining Bachelor's degree or higher (2011-2015).

Limitation: Current report reflects average of 'CH2011_15' for only 2011-2015,
however it did not include the last three to five decades which could provide 
better comparison of U.S.A adult's educational growth for each state, because 
growth in education impacts the growth in economic development.

Possible Follow-up Steps: May expand this report with late year columns
for better comparisons.
;

 proc gchart data=Education_NS2;
 title1 ‘Analysis of Most Well Educated States, USA(2011-2015)’;
format AVGEDU 12.2;
where State in ('DC', 'CA', 'MA' , 'CT', 'NJ');
 label AVGEDU = 'Average of Adults attained Bachelor Degree or higher'
       State  = 'State grouped by Counties';       
vbar State / sumvar=AVGEDU type=mean;

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
		FORMAT=12.2
        LABEL=
            'Deviation Btw DC and TX'
        from
            Education_NS2
        where
            State EQ 'TX' or 
            State EQ 'DC'
    ;
quit; 
title;
footnote;


