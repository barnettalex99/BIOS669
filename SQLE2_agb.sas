%LET job=SQLE2;
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
*  Date:          2/1/22                                      
*------------------------------------------------------------------- 
*  Job name:      SQLE2_agb.sas   
*
*  Purpose: Using the ICUSTAYS data set, implement a macro variable solution to answer 
the question of which care units (using FIRST_CAREUNIT) have an average length of stay that is greater 
than the overall average length of stay for all ICU stays.  The title of the report should include the 
overall average length of stay, and the report itself should include the average length of stay for each 
listed care unit. 
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

PROC SQL Number;

SELECT Avg(LOS) INTO :OverallAverage
    FROM mimic.icustays; 
        
%PUT &OverallAverage;
        
TITLE "Care Units with Greater than &OverallAverage Length of Stay";
 SELECT FIRST_CAREUNIT FORMAT=$unitfmt., Avg(LOS) as AvgStayLength
        FROM mimic.icustays
        GROUP BY FIRST_CAREUNIT
        HAVING AvgStayLength > &OverallAverage
        ORDER BY AvgStayLength DESC;

QUIT;

/* ODS PDF CLOSE; */
/* proc printto; run; /*closes open log file */