*******************************************************************************;
* Added an 80-character banner for reference **********************************;
*******************************************************************************;

*
STAT6250-01_w18-team-5_project1_data_preparation.sas

This file loads the data set to be used in our analysis.

[Dataset Name] County-Level

[Experimental Units] United States Education Attainment

[Number of Observations] 3283

[Number of Features] 47

[Data Source] The file was downloaded from an external website at
https://www.ers.usda.gov/webdocs/DataFiles/48747/Education.xls?v=42762 and was
then edited to remove the top four lines and to add better titles for column
names.

[Data Dictionary] https://www.ers.usda.gov/data-products/county-level-data-sets/county-level-data-sets-download-data/

[Unique ID Schema] The column "FIPS_Code" is a primary key.
;

* environmental setup;

* setup environmental parameters;

%let inputDatasetUrl = https://github.com/stat6250/team-5_project1/blob/master/Education.xls?raw=true
;

* load raw dataset over the wire;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    education_raw,
    &inputDatasetUrl.,
    xls
)

* check raw dataset for duplicates with primary key;
proc sort
        nodupkey
        data=education_raw
        dupout=education_raw_dups
        out=_null_
    ;
    by
        FIPS_Code
    ;
run;
