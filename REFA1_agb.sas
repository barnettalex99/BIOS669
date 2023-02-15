%LET job=REFA1;
%LET onyen=agb;
%LET outdir= /home/u63044704/BIOS699/REFA;
OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME mets "/home/u63044704/my_shared_file_links/klh52250/METS";

*********************************************************************
*  Assignment:    REFA1                                         
*                                                                    
*  Description:   First collection of SAS refresher problems using 
*                           METS study data
*
*  Name:             Alex Barnett
*
*  Date:              1/12/22                         
*------------------------------------------------------------------- 
*  Job name:      REFA1_agb.sas   
*
*  Purpose:       Produce a display for evaluating whether treatment
*                         groups are fairly balanced across the METS sites.
*                                         
*  Language:      SAS, VERSION 9.4  
*
*  Input:         METS data set dr_669 (could also list macros or 
*                      other external files that you are accessing)
*
*  Output:       RTF file (you might also be making permanent data
*                       sets, xls files, etc. that you should list here)     
*                                                                    
********************************************************************;
ods pdf file='/home/u63044704/BIOS699/REFA/REFA1_agb.pdf' pdftoc=2;

proc printto log="/home/u63044704/BIOS699/REFA/REFA1_agb.log";
run;

proc sort data = mets.dr_669 out= mets_by_Psite;
	by Psite;

proc freq data=mets_by_Psite;
    by PSite;
    tables TRT;
run;

ods pdf close;

