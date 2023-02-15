%LET job=SQLE1;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run; /*opens a log file to write to

*********************************************************************
*  Assignment:    SQLE                                       
*                                                                    
*  Description:   Fifth set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          2/1/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLE1_agb.sas   
*
*  Purpose:       Create a single macro variable that contains a list of all unformatted unique care unit names (use FIRST_CAREUNIT) existing in the ICUSTAYS data set
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         MIMIC data
*
*  Output:        Log file      
*                                                                    
********************************************************************;


/* OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN NOFULLSTIMER; */
/* ODS _ALL_ CLOSE; */
/* FOOTNOTE "Job &job._&onyen run on &sysdate at &systime"; */

LIBNAME mimic "~/my_shared_file_links/klh52250/MIMIC" access=readonly; 


PROC SQL NOPRINT;
SELECT DISTINCT FIRST_CAREUNIT INTO :unitlist SEPARATED BY ' '
FROM mimic.icustays;
%PUT &unitlist;

QUIT;


proc printto; run; /*closes open log file