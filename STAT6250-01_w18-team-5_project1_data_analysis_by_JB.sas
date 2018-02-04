*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
STAT6250-01_w18-team-5_project1_data_analysis_by_JB.sas

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
'Research Question: Which counties in the United States have become significantly more urban between 2003 and 2013?'
;

title2
'Rationale: This may serve as a point of reference when comparing levels of educational attainment between those time periods.'
;

footnote1
'Here we see twenty counties that have significantly urbanized from 2003 to 2013.'
;

*
Methodology: This step uses PROC PRINT to display columns from the temporary
file created in the data preparation step. It shows the states, areas, and RUCC
values for the top 20 most urbanized locations.

Limitations: It is unclear at this point if a significant increase in
urbanization based upon RUCC will have an impact on educational attainment.
It may be more useful to sort by ascending recent RUCC first, then by
descending change in RUCC, and finally by descending old RUCC to better
organize the areas by their most recent level of urbanization.

Possible Follow-up Steps: Look into how to deal with missing values so that
the sorting method noted above can be implemented in the future.
;
proc print
        noobs
        label
            data = Education_JB1(obs=20)
    ;
    var
        State
        Area_name
        RUCC2003
        RUCC2013
        urban_increase
    ;
run;
title;
footnote;



title1
'Research Question: In recently urbanized areas, what is the change in educational attainment for each category from 2000 to 2015?'
;

title2
'Rationale: We want to explore how the proportions of educational attainment change when an area becomes heavily urbanized.'
;

footnote1
'It appears that in areas that have become more heavily urbanized, the proportion of highly educated people in that area has generally increased.'
;

*
Methodology: Reusing the sorted temporary data set from the previous step,
display the change in proportions for educational attainment in each area
using the calculated measures found in the data prep file.

Limitations: This calculation was prepared by finding the difference in
the percentage measure found in the original data set. It is possible that
a calculation showing the percent change in the population of adults of
various levels of education in each area would provide a more interesting
result for the purpose of tracking educational attainment with respect to
urbanization.

Possible Follow-up Steps: Explore percent change in population of adults
at each level of education between the two time frames.
;
proc print
        noobs
        label
            data = Education_JB1(obs=20)
    ;
    var
        State
        Area_name
        RUCC2003
        RUCC2013
        urban_increase
        change_PerLHS
        change_PerHS
        change_PerC13
        change_PerCH
    ;
run;
title;
footnote;



title1
'Research Question: How has the population of adults grown in areas that have become heavily urbanized between 2003 and 2013?'
;

title2
'Rationale: Understanding the magnitude of the change in population may help put the percent change of educational attainment into context.'
;

footnote1
'Based on this result, further detailed study may be required to determine if there is a significant link between population increase and level of educational attainment.'
;

*
Methodology: Using the same sorted data set from the previous steps, include
new measures created in the data prep file that compare the population of
adults in each time period and the percent change in adult population. An
earlier iteration of this step included the calculations within the analysis
file rather than in the data prep file.

Limitations: The population figure is not the true population of a given
area, but is the sum of the counts of adults in each category of
educational attainment. Also, for populations that were initially low,
the percent change in population may be highly sensitive to the point
of being meaningless as a measure.

Possible Follow-up Steps: With 13 columns displayed in this step, the
results viewer is becoming unwieldy. It may be appropriate to pare down
which columns are included, or to include different measures that would
more effectively express the relationship between educational attainment
and urbanization. Also, the numbers that are represented as percentages
in this example are displayed as numbers without in-line percent symbols,
due to the format of the data in the original data file. In a future release,
either the format of the data in the original file could be altered, or
additional processing could take place in the data prep step to cast any such
values as percentages. In such a case, any percentages to be represented
could be displayed using the PERCENT9.1 format, with the word "percent" removed
from the column labels to eliminate redundancy.
;
proc print
        noobs
        label
            data = Education_JB1(obs=20)
    ;
    var
        State
        Area_name
        RUCC2003
        RUCC2013
        urban_increase
        change_PerLHS
        change_PerHS
        change_PerC13
        change_PerCH
        pop2000
        pop2015
        change_pop2000_2015
        perChange_pop2000_2015
    ;
    format
        pop2000 comma9.
        pop2015 comma9.
        change_pop2000_2015 comma9.
        perChange_pop2000_2015 comma9.1
    ;
run;
title;
footnote;
