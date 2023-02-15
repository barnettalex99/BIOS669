%LET job=SQLF2;
%LET onyen=agb;
%LET outdir=/home/u63044704/BIOS669;

proc printto log="&outdir/Logs/&job._&onyen..log" new; run;

*********************************************************************
*  Assignment:    SQLF2                                      
*                                                                    
*  Description:   Sixth set of SQL Practice Problems 
*
*  Name:          Alex Barnett
*
*  Date:          2/6/23                                      
*------------------------------------------------------------------- 
*  Job name:      SQLF2_agb.sas   
*
*  Purpose:       Redo REFA3 using PROC SQL
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


/* PDF output */
ODS PDF FILE="&outdir/PDFs/&job._&onyen..PDF" STYLE=JOURNAL;

TITLE 'Participants with Randomization and Screening Dates Less Than 3 Or More Than 14 Days Apart';

PROC SQL Number;

CREATE TABLE joinedDates AS
	SELECT ieca.BID, IECA0B, RDMA0B, PSITE
	FROM mets.ieca_669 as ieca, mets.rdma_669 as rdma, mets.dr_669 as dr
	WHERE ieca.BID = rdma.BID AND ieca.BID = dr.BID;
	
SELECT BID, IECA0B, RDMA0B, PSITE,INTCK('day',IECA0B, RDMA0B) as DaysApart 
FROM joinedDates
WHERE ((INTCK('day',IECA0B, RDMA0B)) >14) or ((INTCK('day',IECA0B, RDMA0B))<3);

QUIT;


ODS PDF CLOSE;

proc printto; run; /*closes open log file*/