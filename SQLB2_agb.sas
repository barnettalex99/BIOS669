%LET job=SQLB2;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

 proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to 

*********************************************************************
*  Assignment:    SQLB                                        
*                                                                    
*  Description:   Second set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          1/23/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLB2_agb.sas   
*
*  Purpose:       Learn more about PROC SQL
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         MIMIC data
*
*  Output:        PDF file      
*                                                                    
********************************************************************; */


OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER;
ODS _ALL_ CLOSE;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";



/* PDF output */
ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL;

LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly;

proc format; 
	value $unitfmt
		'CCU' = "Coronary Care Unit"
		'CSRU' = "Cardiac Surgery Recovery Unit"
		'MICU' = "Medical Intensive Care Unit"
		'NICU' = "Neonatal Intensive Care Unit"
		'NWARD' = "Neonatal Ward"
		'SICU' = "Surgical Intensive Care Unit"
		'TSICU' = "Trauma/Surgical Intensive Care Unit"
	; 
run; 

PROC SQL NUMBER; 

CREATE TABLE Question2A AS 
  	SELECT FIRST_CAREUNIT FORMAT=$unitfmt.as Unit, COUNT(FIRST_CAREUNIT) as NumOfStays, SUM (LOS) as TotalLength
    FROM mimic.icustays
    GROUP BY FIRST_CAREUNIT;

TITLE '2A) ICU Stays by Unit';
	SELECT *
	FROM Question2A
	ORDER BY NumOfStays DESC;
	
CREATE TABLE Question2B AS 
  	SELECT SUBJECT_ID, FIRST_CAREUNIT FORMAT=$unitfmt.as Unit, COUNT(FIRST_CAREUNIT) as NumOfStays, SUM (LOS) as TotalLength
    FROM mimic.icustays
    GROUP BY FIRST_CAREUNIT, SUBJECT_ID;
	
TITLE '2B) Distinct ICU Subjects by Unit';
	SELECT Unit, COUNT(SUBJECT_ID) as SubjectCount
	FROM Question2B
	GROUP BY Unit;

CREATE TABLE Question2C AS 
  	SELECT FIRST_CAREUNIT FORMAT=$unitfmt.as Unit, COUNT(FIRST_CAREUNIT) as NumOfStays, SUM (LOS) as TotalLength
    FROM mimic.icustays
    GROUP BY FIRST_CAREUNIT;

TITLE '2C) Average ICU Stay Length by Unit';
	SELECT * , TotalLength/ NumOfStays as AverageStayLength
	FROM Question2C
	ORDER BY AverageStayLength DESC;

QUIT; 

TITLE '2D) PROC MEANS';
PROC MEANS data=mimic.icustays out= means_output;
by FIRST_CAREUNIT;
output out= means_output;
run;

proc print data=means_output;
run;

ODS PDF CLOSE;

proc printto; run; /*closes open log file



