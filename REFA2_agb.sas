*********************************************************************
*  Assignment:    REFA2                                         
*                                                                    
*  Description:   First collection of SAS refresher problems using 
*                           METS study data
*
*  Name:             Alex Barnett
*
*  Date:              1/12/22                         
*------------------------------------------------------------------- 
*  Job name:      REFA2_agb.sas   
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
%LET job=REFA2;
%LET onyen=agb;
%LET outdir= /home/u63044704/BIOS699/REFA;
OPTIONS NODATE MPRINT MERGENOBY=WARN VARINITCHK=WARN;
FOOTNOTE "Job &job._&onyen run on &sysdate at &systime";
LIBNAME mets "/home/u63044704/my_shared_file_links/klh52250/METS";
/* proc printto log="/home/u63044704/BIOS699/REFA/REFA2_agb.log"; */

ods pdf file='/home/u63044704/BIOS699/REFA/REFA2_agb.pdf' pdftoc=2;

proc print data = mets.omra_669;
	var BID OMRA1;
	where OMRA1 IN ('CIMETIDINE','AMILORIDE','DIGOXIN','MORPHINE','PROCAINAMIDE','QUINIDINE','QUININE','RANITIDINE','TRIAMTERENE','TRIMETHOPRIM','VANCOMYCIN','FUROSEMIDE','NIFEDIPINE');
run;

ods pdf close;