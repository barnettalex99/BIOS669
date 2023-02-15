%LET job=SQLC2;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to */

*********************************************************************
*  Assignment:    SQLC                                         
*                                                                    
*  Description:   First set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          1/26/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLC2_agb.sas   
*
*  Purpose:       Produce a joined table using both SQL and SAS
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         MIMIC data
*
*  Output:        PDF file      
*                                                                    
********************************************************************;


OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER;
ODS _ALL_ CLOSE;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";

LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly; 


/* PDF output */
ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL;


PROC SQL NUMBER;

CREATE TABLE chart_schedule1 AS
	select P.SUBJECT_ID, A.ADMISSION_TYPE, P.GENDER, CG.CGID, CG.LABEL, D.LABEL as TaskLabel, DATEPART(CE.CHARTTIME) FORMAT = DATE. as DATE
	from mimic.chartevents as CE,
		mimic.caregivers as CG,
		mimic.d_items as D,
		mimic.patients as P,
		mimic.admissions as A
	where CE.CGID = CG.CGID AND CE.ITEMID = D.ITEMID AND CE.HADM_ID = A.HADM_ID AND P.SUBJECT_ID = CE.SUBJECT_ID AND P.SUBJECT_ID = A.SUBJECT_ID AND (CG.LABEL = 'RN') AND (DATEPART(CE.CHARTTIME) = '06FEB2107'D)
	order by CHARTTIME, CGID DESC, D.Label;

QUIT;

TITLE "A)Chart Schedule Join via SQL";

proc print data=chart_schedule1 (obs=10);
run;


TITLE "B) Chart Schedule Join via SAS Only";
/*sorts Patients and Admissions by subject ID and merges those */
PROC SORT DATA=mimic.patients OUT=sortedPatients;    
BY SUBJECT_ID;    
RUN;

PROC SORT DATA=mimic.admissions OUT=sortedAdmissions;    
BY SUBJECT_ID;    
RUN;

data merge1;
	merge sortedPatients sortedAdmissions;
	by SUBJECT_ID;
run;

/*sorts Merge1 and ChartEvents by HADM_ID and merges those */
PROC SORT DATA=mimic.chartevents OUT=sortedChartEvents;    
BY HADM_ID;    
RUN;

PROC SORT DATA=merge1 OUT=sortedMerge1;    
BY HADM_ID;    
RUN;

data merge2;
	merge sortedChartEvents sortedMerge1;
	by HADM_ID;
run;

/*sorts by CGID and merges that in */

PROC SORT DATA=mimic.caregivers OUT=sortedCareGivers;    
BY CGID;    
RUN;

PROC SORT DATA=merge2 OUT=sortedMerge2;    
BY CGID;    
RUN;

data merge3;
	merge sortedCareGivers sortedMerge2;
	by CGID;
	rename LABEL = CaregiverLabel;
run;

/*sorts by ITEM_ID and merges those */

PROC SORT DATA=merge3 OUT=sortedMerge3;    
BY ITEMID;
RUN;

PROC SORT DATA=mimic.d_items OUT=sortedItems;    
BY ITEMID;    
RUN;

data merge4;
	merge sortedMerge3 sortedItems;
	by ITEMID;
	rename LABEL = TaskLabel;
run;

/* Sorts final data set by proper order */
PROC SORT data=merge4 OUT=sortedMerge4;
	by CHARTTIME DESCENDING CGID TaskLabel;
run;

/* Filters proper data from set */
data chart_schedule2;
	set sortedMerge4 (KEEP = SUBJECT_ID ADMISSION_TYPE GENDER CGID TaskLabel CHARTTIME CaregiverLabel);
	where (CaregiverLabel = 'RN') AND (DATEPART(CHARTTIME) = '06FEB2107'D);
run;
	

proc print data=chart_schedule2 (obs=10);
run;

TITLE "C) Using Proc Contents To Compare Datasets";
PROC COMPARE BASE=chart_schedule1 COMPARE=chart_schedule2 LISTALL; 
RUN;



ODS PDF CLOSE;

proc printto; run; /*closes open log file */