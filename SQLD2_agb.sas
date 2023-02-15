%LET job=SQLD2;
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
*  Job name:      SQLD1_agb.sas   
*
*  Purpose:       Multi-step problem using nested subqueries
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


PROC SQL NUMBER;

TITLE 'A) Maximum Length of Stay for Each Patient';
 SELECT SUBJECT_ID, Max(LOS) as MaxStayLength
        FROM mimic.icustays
        GROUP BY SUBJECT_ID
        ORDER BY MaxStayLength DESC;

TITLE 'B) Maximum Length of Stay for Each Care Unit';
 SELECT FIRST_CAREUNIT FORMAT=$unitfmt., Max(LOS) as MaxStayLength
        FROM mimic.icustays
        GROUP BY FIRST_CAREUNIT
        ORDER BY MaxStayLength DESC;
        
TITLE 'C) Average Length of Stay for Each Care Unit';
 SELECT FIRST_CAREUNIT FORMAT=$unitfmt., Avg(LOS) as AvgStayLength
        FROM mimic.icustays
        GROUP BY FIRST_CAREUNIT
        ORDER BY AvgStayLength DESC;
        
TITLE 'D) Overall Average Length of Stay';
 SELECT Avg(LOS) as OverallAvgStayLength
        FROM mimic.icustays; 
        
%LET OverallAverage=OverallAvgStayLength;
        
TITLE 'E) Care Units with Greater than Average Length of Stay';
 SELECT FIRST_CAREUNIT FORMAT=$unitfmt., Avg(LOS) as AvgStayLength
        FROM mimic.icustays
        GROUP BY FIRST_CAREUNIT
        HAVING AvgStayLength > 
        	(SELECT Avg(LOS) as OverallAvgStayLength
        	 FROM mimic.icustays)
        ORDER BY AvgStayLength DESC;

QUIT;


/* ODS PDF CLOSE; */
/*  */
/* proc printto; run; /*closes open log file */ */