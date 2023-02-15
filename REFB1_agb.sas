%LET job=REFB1;
%LET onyen=agb;
%LET outdir= /home/u63044704/BIOS699/REFB;
OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME mets "/home/u63044704/my_shared_file_links/klh52250/METS";

*********************************************************************
*  Assignment:    REFB1                                         
*                                                                    
*  Description:   First collection of SAS refresher problems using 
*                           METS study data
*
*  Name:             Alex Barnett
*
*  Date:              1/12/22                         
*------------------------------------------------------------------- 
*  Job name:      REFB1_agb.sas   
*
*  Purpose:       Produce a display for evaluating whether treatment
*                         groups are fairly balanced across the METS sites.
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         METS data set dr_669 (could also list macros or 
*                      other external files that you are accessing)
*
*  Output:       PDF file (you might also be making permanent data
*                       sets, xls files, etc. that you should list here)     
*                                                                    
********************************************************************;
/* ods pdf file='/home/u63044704/BIOS699/REFB/REFB1_agb.pdf'; */

proc printto log="/home/u63044704/BIOS699/REFB/REFB1_agb.log";

title 'Frequency of Age and Gender in METS participants';

proc freq data = mets.dema_669;
	tables DEMA1 * DEMA2 / norow nocol nopercent;
run;

/* ods pdf close; */

