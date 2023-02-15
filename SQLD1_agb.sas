%LET job=SQLD1;
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
*  Purpose:       Using nested subqueries
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

TITLE 'All Female Admissions';
PROC SQL NUMBER;

 SELECT SUBJECT_ID, DATEPART(ADMITTIME) FORMAT = DATE7. as Date, DIAGNOSIS
        FROM mimic.admissions
        WHERE SUBJECT_ID IN  
            (SELECT SUBJECT_ID 
                FROM mimic.patients 
                WHERE UPCASE(GENDER)='F'); 

QUIT;


/* ODS PDF CLOSE; */
/*  */
/* proc printto; run; /*closes open log file */ */