%LET job=SQLD3;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

/* proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to */

*********************************************************************
*  Assignment:    SQLD                                       
*                                                                    
*  Description:   Fourth set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          1/30/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLD3_agb.sas   
*
*  Purpose:       Finding patients who had a stay in more than one different kind of care unit
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
/*  */
LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly; 


/* PDF output */
/* ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL; */

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

TITLE 'Patients Who Stayed in Multiple Care Units';

PROC SQL NUMBER;

 SELECT Distinct SUBJECT_ID, FIRST_CAREUNIT FORMAT=$unitfmt.
        FROM mimic.icustays
        GROUP BY SUBJECT_ID
        HAVING COUNT(DISTINCT(FIRST_CAREUNIT)) >= 2;
        
QUIT;


/* ODS PDF CLOSE; */
/*  */
/* proc printto; run; /*closes open log file */ */