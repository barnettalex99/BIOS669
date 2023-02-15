%LET job=SQLA3;
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
*  Job name:      SQLA3_agb.sas   
*
*  Purpose:       Produce a display for evaluating whether treatment
*                 groups are fairly balanced across the METS sites.
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
  TITLE 'List of Insurance Types ';
  SELECT DISTINCT INSURANCE
  FROM mimic.admissions
  ORDER BY INSURANCE;
  
  TITLE 'Number of Unique Discharge Locations ';
  SELECT COUNT (DISTINCT DISCHARGE_LOCATION)
  FROM mimic.admissions;
  
   TITLE 'Number of Discharges at Each Location ';
  	SELECT DISCHARGE_LOCATION, COUNT(*) as NumberDischarged
  	FROM mimic.admissions
  	GROUP BY DISCHARGE_LOCATION;
    
QUIT; 

ODS PDF CLOSE;

proc printto; run; /*closes open log file

