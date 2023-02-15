%LET job=SQLE3;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

/* proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to */

*********************************************************************
*  Assignment:    SQLE                                       
*                                                                    
*  Description:   Fifth set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          2/1/23                                      
*------------------------------------------------------------------- 
*  Job name:      SQLE3_agb.sas   
*
*  Purpose:       Write a macro that, when provided with an item ID, will list all patients who had an average 
recorded measurement of that type during their hospital stay that was above the overall average for 
that item ID
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         MIMIC data
*
*  Output:        PDF file      
*                                                                    
********************************************************************;


/* OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER; */
/* ODS _ALL_ CLOSE; */
/* FOOTNOTE "Job &job._&onyen run on &sysdate at &systime"; */

LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly; 


/* PDF output */
/* ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL; */

PROC SQL Number noprint;

%LET SELECTED_ITEM_ID=220045;

CREATE TABLE ALL_SELECTED_ITEMS AS
	SELECT *
    FROM mimic.chartevents
    Where ITEMID = &SELECTED_ITEM_ID; 

SELECT Avg(VALUENUM)
	FROM ALL_SELECTED_ITEMS
	GROUP BY HADM_ID;
    
SELECT Avg(VALUENUM) INTO :OverallAverage
    FROM ALL_SELECTED_ITEMS;  
    
SELECT LABEL INTO :ItemName
	FROM mimic.d_items
	where itemid = &SELECTED_ITEM_ID;
        
%PUT &OverallAverage;
%PUT &ItemName;

/* merge admissions info in so that we can access diagnosis */

CREATE TABLE merged_table AS
	select ASI.SUBJECT_ID, ASI.HADM_ID, ASI.ITEMID, ASI.VALUENUM, ADM.DIAGNOSIS
	from ALL_SELECTED_ITEMS as ASI,
		mimic.admissions as ADM
	where ASI.HADM_ID = ADM.HADM_ID;


/* create table that gets average recorded value for the ITEMID each HADM_ID */
reset print;

TITLE "Patients with Greater than &OverallAverage Value for their &ItemName Measurements (ID = &SELECTED_ITEM_ID) During A Hospital Stay";
SELECT DISTINCT (HADM_ID), Avg(VALUENUM) as AverageAdmissionValue, SUBJECT_ID, DIAGNOSIS
	FROM merged_table
	GROUP BY HADM_ID, DIAGNOSIS
	HAVING AverageAdmissionValue > &OverallAverage
	ORDER BY SUBJECT_ID, HADM_ID;

/*START AGAIN HERE WITH DIFFERENT MACRO */
reset noprint;
%LET SELECTED_ITEM_ID=220179;

CREATE TABLE ALL_SELECTED_ITEMS AS
	SELECT *
    FROM mimic.chartevents
    Where ITEMID = &SELECTED_ITEM_ID; 

SELECT Avg(VALUENUM)
	FROM ALL_SELECTED_ITEMS
	GROUP BY HADM_ID;
    
SELECT Avg(VALUENUM) INTO :OverallAverage
    FROM ALL_SELECTED_ITEMS;  
    
SELECT LABEL INTO :ItemName
	FROM mimic.d_items
	where itemid = &SELECTED_ITEM_ID;
        
%PUT &OverallAverage;
%PUT &ItemName;

/* merge admissions info in so that we can access diagnosis */

CREATE TABLE merged_table AS
	select ASI.SUBJECT_ID, ASI.HADM_ID, ASI.ITEMID, ASI.VALUENUM, ADM.DIAGNOSIS
	from ALL_SELECTED_ITEMS as ASI,
		mimic.admissions as ADM
	where ASI.HADM_ID = ADM.HADM_ID;


/* create table that gets average recorded value for the ITEMID each HADM_ID */
reset print;

TITLE "Patients with Greater than &OverallAverage Value for their &ItemName Measurements (ID = &SELECTED_ITEM_ID) During A Hospital Stay";
SELECT DISTINCT (HADM_ID), Avg(VALUENUM) as AverageAdmissionValue, SUBJECT_ID, DIAGNOSIS
	FROM merged_table
	GROUP BY HADM_ID, DIAGNOSIS
	HAVING AverageAdmissionValue > &OverallAverage
	ORDER BY SUBJECT_ID, HADM_ID;
	

QUIT;


/* ODS PDF CLOSE; */

/* proc printto; run; /*closes open log file */