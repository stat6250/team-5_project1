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
'Report reflects the average of educational level in Bachelor Degree or higher, grouped by Counties for each state in(2011-2015)'
;

*
Methodology: First use If statements to DELETE all those observations using 
column 'Area_Name' which has country name(United State) and States(excluding 
Counties).This will calculate an accurae SUM for each state, else averages 
will calculate inacurate (that includes States and Country(U.S.A) data along 
with Counuties data). Then next Use PROC MEANS to calculate average number 
of adults grouped by county for per state who have achieved the specified 
level of educational level i.e Bachelor Degree or higher, of USA population 
for 2011-2015 using column "CH2011_15" in the temporary dataset.

Limitations: Current report reflects average for only 2011-2015, however 
by including the last three to five decades could provide better comparison 
of U.S.A adult's educational growth for each state. 

Possible Follow-up Steps: The way I tried to DELETE the observations of 
Country and State through SAS coding, need more research to delete the 
same in a more efficent way.Performace tunning of code needs to taken care,
if any.
;
DATA 
		Education_temp
	;
	set 
		Work.Education_analytic_file
	;
    IF 
		Area_name = 'United States' OR Area_name = 'Alabama' 
    	OR Area_name = 'Alaska' OR Area_name = 'Arizona' 
    	OR Area_name = 'California' OR Area_name = 'Colorado' 
    	OR Area_name = 'Connecticut' OR Area_name = 'Delaware' 
    	OR Area_name = 'Florida' OR Area_name = 'Georgia' 
		OR Area_name = 'Hawaii'	OR Area_name = 'Idaho' 
		OR Area_name = 'Illinois' OR Area_name = 'Indiana'
    	OR Area_name = 'Iowa' OR Area_name = 'Kansas' 
		OR Area_name = 'Kentucky' OR Area_name = 'Lousiana' 
		OR Area_name = 'Maine' OR Area_name = 'Maryland'
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
    	OR Area_name = 'Texas' OR Area_name = 'Utah' 
		OR Area_name = 'Vermont' OR Area_name = 'Virginia' 
		OR Area_name = 'Washington' OR Area_name = 'West Virginia' 
		OR Area_name = 'Wisconsin' OR Area_name = 'Wyoming' 
		OR Area_name = 'Puerto Rico' 
	THEN DELETE
	;
RUN;
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
'Research Question: Which State is the most well-educated who attained Bachelor Degree or higher(2011-2015)?'
;

title2
'Rationale: This would help us to know the top most well-educated state in USA for the year (2011-2015).'
;

footnote1
'Now we see the most well educated state i.e "DC", attained the Bachelor Degree or higher educational level(2011-2015).'
;

*
Methodology: Once we got the Mean for each state(from above),now will compute
highest mean from all States to know which state scored highest in 
education level in attaining Bachelor's degree or higher(2011-2015).

Limitation: Current report reflects average of 'CH2011_15' for only 2011-2015,
however it did not include the last three to five decades which could provide 
better comparison of U.S.A adult's educational growth for each state, beacuse 
growth in education impacts the growth in economic development.

Possible Follow-up Steps: Formating is required such as label the columns 
with meaningful name(Costomizing column name) if possible without changing 
column lables in dataset preparation file using SAS code. 
Performace tunning of code needs to taken care,if any. 
;
PROC SORT 
		DATA=Education_temp1 
		OUT=Education_max
	;
	BY decending 
		AVGEDU
	;
run;
proc print 
		noobs data=Education_max
	;
	var 
		State AVGEDU
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
'Report dipicts the comaprison between two states (District of Colombia and Texas) of adults avarage population who attained Bachelor Degree or higher (2011-2015).'
;
 
*
Methodology: Using temporary data file from previous step, select average 
value of adults from Texas(TX) and District of Colombia(DC) using 
PROC SQL...QUIT procedure.

Limitations: This report has choosen state Texas for comparison, without
taking any consideration of choosing any state with 1st or 3rd quartiles
or median of total average from the available states in the dataset.

Possible Follow-up Steps: For future step, determining the 1st/3rd quartile
or median of mean column(AVGDU)for comparing with the most well educated
state. Performace tunning(code) needs to taken care,if any. 
;
PROC SQL
	;
	SELECT 
		State, AVGEDU
	FROM 
		Education_max
	WHERE 
		State EQ 'TX' OR State EQ 'DC'
	;
QUIT; 
title;
footnote;


