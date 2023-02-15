%LET job=SQLB1;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

/* proc printto log="&outdir/Logs/&job._&onyen..log" new; run; opens a log file to write to */

*********************************************************************
*  Assignment:    SQLB                                        
*                                                                    
*  Description:   Second set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          1/23/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLB1_agb.sas   
*
*  Purpose:       Learn more about PROC SQL
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



/* PDF output */
/* ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL; */

LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly;

PROC SQL NUMBER; 

CREATE TABLE Question1 AS 
  	SELECT SUBJECT_ID, COUNT(SUBJECT_ID) as NumOfStays, SUM (LOS) as TotalLength
    FROM mimic.icustays
    GROUP BY SUBJECT_ID;

TITLE '1A) ICU Stays and Length by Number of Stays';
	SELECT *
	FROM Question1
	ORDER BY NumOfStays DESC;
	
TITLE '1B) ICU Stays Greater Than 2 Times or 20 Days';
	SELECT *
	FROM Question1
	WHERE NumOfStays > 2 or TotalLength > 20
	ORDER BY NumOfStays DESC;
	
QUIT; 

/* ODS PDF CLOSE; */
/*  */
/* proc printto; run; /*closes open log file */



