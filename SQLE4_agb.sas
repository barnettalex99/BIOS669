%LET job=SQLE4;
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
*  Job name:      SQLE4_agb.sas   
*
*  Purpose:       ADMISSIONS data set and an inexact match technique to find patients 
(subject ID numbers) who were admitted to the hospital in two consecutive months or within the same 
month in the same year
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

TITLE 'Patients Admitted in Same or Consecutive Months';

PROC SQL Number;
SELECT a.SUBJECT_ID,
 DATEPART(a.ADMITTIME) LABEL="Admission" FORMAT=DATE11.,
 a.DIAGNOSIS LABEL="REASON FOR FIRST ADMISSION",
 DATEPART(b.ADMITTIME) LABEL="Re-admission within 1 month" FORMAT=DATE11.,
 b.DIAGNOSIS LABEL="REASON FOR SECOND ADMISSION"
	FROM mimic.admissions AS a, mimic.admissions AS b
	WHERE a.SUBJECT_ID = b.SUBJECT_ID AND /* match on patient ID */
		DATEPART(a.ADMITTIME) < DATEPART(b.ADMITTIME) AND /* only if admit before re-admit */
		YEAR(DATEPART(b.ADMITTIME)) = YEAR(DATEPART(a.ADMITTIME)) AND /* only if year is the same */
		MONTH(DATEPART(b.ADMITTIME)) = MONTH(DATEPART(a.ADMITTIME)+1) /* only if month is the same or 1 late */
	ORDER BY YEAR(DATEPART(a.ADMITTIME)), MONTH(DATEPART(a.ADMITTIME)), SUBJECT_ID;
	

QUIT;


/* ODS PDF CLOSE; */

/* proc printto; run; /*closes open log file */