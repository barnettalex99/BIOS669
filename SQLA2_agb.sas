
%LET job=SQLA2;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to

*********************************************************************
*  Assignment:    SQLA                                         
*                                                                    
*  Description:   First set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          1/19/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLA2_agb.sas   
*
*  Purpose:       Check time taken to acknowledge discharge requests
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         MIMIC data
*
*  Output:        PDF file      
*                                                                    
********************************************************************;
*/

OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER;
ODS _ALL_ CLOSE;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";

LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly;


/* PDF output */
ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL;

PROC SQL NUMBER; 

CREATE TABLE Question2 AS 
  	SELECT HADM_ID, INTCK('min', CREATETIME, OUTCOMETIME) as TOTALTIME, (INTCK('min', CREATETIME, ACKNOWLEDGETIME))/(INTCK('min', CREATETIME, OUTCOMETIME)) as PERCENTACKNOWLEDGETIME FORMAT = percent12.1
    FROM mimic.callout;

TITLE 'Percentage of Time Spent Waiting for Acknowledgement';
	SELECT HADM_ID, TOTALTIME, PERCENTACKNOWLEDGETIME
	FROM Question2
	WHERE PERCENTACKNOWLEDGETIME is not missing
	ORDER BY PERCENTACKNOWLEDGETIME DESC;
QUIT; 

ODS PDF CLOSE;

proc printto; run; /*closes open log file



