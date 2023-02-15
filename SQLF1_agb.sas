%LET job=SQLF1;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run;

*********************************************************************
*  Assignment:    SQLF1                                      
*                                                                    
*  Description:   Sixth set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          2/6/23                                      
*------------------------------------------------------------------- 
*  Job name:      SQLF1_agb.sas   
*
*  Purpose:       Redo REFA2 using PROC SQL
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

LIBNAME mets "~/my_shared_file_links/klh52250/METS" access=readonly; 

TITLE 'Participants With Restricted Drug Use';
/* PDF output */
ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL;

PROC SQL Number;

SELECT BID, OMRA1 
FROM mets.omra_669
WHERE OMRA5A = 'Y' AND OMRA1 IN ('CIMETIDINE','AMILORIDE','DIGOXIN','MORPHINE','PROCAINAMIDE','QUINIDINE','QUININE','RANITIDINE','TRIAMTERENE','TRIMETHOPRIM','VANCOMYCIN','FUROSEMIDE','NIFEDIPINE');
QUIT;


ODS PDF CLOSE;

proc printto; run; /*closes open log file */